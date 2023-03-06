//
//  File.swift
//
//
//  Created by Valentin Radu on 05/03/2023.
//

import Combine
import CryptoKit
import Foundation
import Network
import os

extension NWParameters {
    static func securePeerConnectionParameters<PeerMessageKind>(password: Data,
                                                                relaying: PeerMessageKind.Type) -> NWParameters
        where PeerMessageKind: PeerMessageKindProtocol {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let tlsOptions = NWProtocolTLS.Options()
        let authenticationKey = SymmetricKey(data: password)
        let identity = "com.peertunnel.framework"
        let identityData = identity.data(using: .utf8)!
        var authenticationCode = HMAC<SHA256>.authenticationCode(for: identityData,
                                                                 using: authenticationKey)

        let authenticationDispatchData = withUnsafeBytes(of: &authenticationCode) { (ptr: UnsafeRawBufferPointer) in
            DispatchData(bytes: ptr)
        }

        let identityDispatchData = withUnsafeBytes(of: identityData) { (ptr: UnsafeRawBufferPointer) in
            DispatchData(bytes: UnsafeRawBufferPointer(start: ptr.baseAddress, count: identityData.count))
        }

        sec_protocol_options_add_pre_shared_key(tlsOptions.securityProtocolOptions,
                                                authenticationDispatchData as __DispatchData,
                                                identityDispatchData as __DispatchData)
        sec_protocol_options_append_tls_ciphersuite(tlsOptions.securityProtocolOptions,
                                                    tls_ciphersuite_t(rawValue: TLS_PSK_WITH_AES_128_GCM_SHA256)!)

        let parameters = NWParameters(tls: tlsOptions, tcp: tcpOptions)
        parameters.includePeerToPeer = true

        let protocolOptions = NWProtocolFramer.Options(definition: PeerMessageDefinition.definition)
        parameters.defaultProtocolStack.applicationProtocols.insert(protocolOptions, at: 0)

        return parameters
    }
}

public class PeerConnection<PeerMessageKind> where PeerMessageKind: PeerMessageKindProtocol {
    private let _logger: Logger = .init(subsystem: "com.peertunnel.framework", category: "peer-connection")
    private let _connection: NWConnection

    public let messages: PassthroughSubject<PeerMessage<PeerMessageKind>, Never>

    init(to endpoint: NWEndpoint, password: String) {
        let password = password.data(using: .utf8)!
        let parameters = NWParameters.securePeerConnectionParameters(password: password, relaying: PeerMessageKind.self)
        let connection = NWConnection(to: endpoint, using: parameters)
        _connection = connection
        messages = PassthroughSubject()

        connection.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._connectionStateUpdateHandler(newState: newState)
        }

        connection.start(queue: .main)
    }

    init(wrapping connection: NWConnection) {
        messages = PassthroughSubject()
        _connection = connection
        _connection.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._connectionStateUpdateHandler(newState: newState)
        }
        _connection.start(queue: .main)
    }

    deinit {
        _connection.cancel()
    }

    public func send(kind: PeerMessageKind, data: Data) {
        let message = NWProtocolFramer.Message(kind: kind.rawValue)
        let context = NWConnection.ContentContext(identifier: "peertunnel.connection.messasge",
                                                  metadata: [message])

        _connection.send(
            content: data,
            contentContext: context,
            isComplete: true,
            completion: .idempotent
        )
    }

    private func _receiveNextMessage() {
        _connection.receiveMessage { [weak self] content, context, isComplete, error in
            guard let self else { return }

            if let context,
               let metadata = context.protocolMetadata(definition: PeerMessageDefinition.definition),
               let message = metadata as? NWProtocolFramer.Message,
               let kind = PeerMessageKind(rawValue: message.kind),
               let content {
                self.messages.send(.init(kind: kind, data: content))
            }

            if error == nil {
                self._receiveNextMessage()
            }
        }
    }

    private func _connectionStateUpdateHandler(newState: NWConnection.State) {
        let connectionDebugDescription = _connection.debugDescription
        switch newState {
        case .ready:
            _logger.info("\(connectionDebugDescription) established")
            _receiveNextMessage()
        case let .failed(error):
            _logger.fault("\(connectionDebugDescription) failed with \(error)")
            _connection.cancel()
        default:
            break
        }
    }
}
