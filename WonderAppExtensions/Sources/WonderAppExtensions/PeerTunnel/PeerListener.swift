//
//  File.swift
//
//
//  Created by Valentin Radu on 04/03/2023.
//
import CryptoKit
import Foundation
import Network
import os

public enum PeerListenerError: Error {
    case alreadyListening
    case alreadyWaitingConnection
    case timeout
}

public class PeerListener {
    private let _listener: NWListener
    private let _logger: Logger = .init(subsystem: "com.peertunnel", category: "peer-listener")
    private var _connection: PeerConnection?
    private var _connectionContinuation: CheckedContinuation<PeerConnection, Error>?

    public init(name: String) throws {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        let protocolOptions = NWProtocolFramer.Options(definition: PeerMessageDefinition.definition)
        parameters.defaultProtocolStack.applicationProtocols.insert(protocolOptions, at: 0)

        let listener = try NWListener(using: parameters)
        listener.service = NWListener.Service(name: name, type: "_peertunnel._tcp")

        _listener = listener
    }

    public func listen() throws {
        if _listener.state != .setup {
            throw PeerListenerError.alreadyListening
        }

        _listener.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._listenerStateUpdateHandler(newState: newState)
        }

        _listener.newConnectionHandler = { [weak self] newConnection in
            guard let self else { return }
            self._listenerNewConnectionHandler(newConnection: newConnection)
        }

        _listener.start(queue: .main)
    }

    public func waitForConnection() async throws -> PeerConnection {
        guard _connection == nil else {
            throw PeerListenerError.alreadyWaitingConnection
        }

        let task = Task {
            try await withCheckedThrowingContinuation {
                _connectionContinuation = $0
            }
        }

        let timeoutTask = Task {
            try await Task.sleep(for: .seconds(10))
            try Task.checkCancellation()
            task.cancel()
        }

        let result = try await task.value
        timeoutTask.cancel()

        return result
    }

    private func _listenerStateUpdateHandler(newState: NWListener.State) {
        switch newState {
        case .ready:
            let portDebugDescription = _listener.port?.debugDescription ?? "unknown port"
            _logger.info("Listener ready on \(portDebugDescription)")
        case let .failed(error):
            _logger.fault("Listener failed with \(error), stopping")
            assertionFailure(error.debugDescription)
            _listener.cancel()
            _connection = nil
            _connectionContinuation?.resume(throwing: error)
        default:
            break
        }
    }

    private func _listenerNewConnectionHandler(newConnection: NWConnection) {
        if _connection != nil {
            newConnection.cancel()
            return
        }

        let newPeerConnection = PeerConnection(rawConnection: newConnection)
        _connection = newPeerConnection
        _connectionContinuation?.resume(returning: newPeerConnection)
        _connectionContinuation = nil
    }
}
