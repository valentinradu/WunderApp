//
//  File.swift
//
//
//  Created by Valentin Radu on 05/03/2023.
//

import Combine
import Foundation
import Network
import os

public class PeerConnection {
    private let _connection: NWConnection
    private let _logger: Logger = .init(subsystem: "com.peertunnel", category: "peer-connection")

    init(to endpoint: NWEndpoint) {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        let protocolOptions = NWProtocolFramer.Options(definition: PeerMessageDefinition.definition)
        parameters.defaultProtocolStack.applicationProtocols.insert(protocolOptions, at: 0)

        let connection = NWConnection(to: endpoint, using: parameters)
        _connection = connection

        connection.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._rawConnectionStateUpdateHandler(newState: newState)
        }

        connection.start(queue: .main)
    }

    init(rawConnection: NWConnection) {
        _connection = rawConnection
        _connection.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._rawConnectionStateUpdateHandler(newState: newState)
        }
        _connection.start(queue: .main)
    }

    deinit {
        _connection.cancel()
    }

    public func send<V>(value: V) async throws where V: Codable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)

        let message = NWProtocolFramer.Message(peerMessageKind: .custom)
        let context = NWConnection.ContentContext(identifier: "peertunnel.connection.custom-message",
                                                  metadata: [message])

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            _connection.send(
                content: data,
                contentContext: context,
                isComplete: true,
                completion: .contentProcessed { error in
                    if let error {
                        continuation.resume(with: .failure(error))
                    } else {
                        continuation.resume()
                    }
                }
            )
        }
    }

    private func _receiveNextMessage() {
        _connection.receiveMessage { [_logger] content, context, isComplete, error in
            if let context,
               let metadata = context.protocolMetadata(definition: PeerMessageDefinition.definition),
               let message = metadata as? NWProtocolFramer.Message {
                switch message.peerMessageKind {
                case .invalid:
                    _logger.error("Received invalid message")
                case .custom:
                    if let content {
                        let decoder = JSONDecoder()
                        let result = try! decoder.decode(String.self, from: content)
                        print(result)
                    }
                }
            }

            if error == nil {
                self._receiveNextMessage()
            }
        }
    }

    private func _rawConnectionStateUpdateHandler(newState: NWConnection.State) {
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
