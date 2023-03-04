//
//  File.swift
//
//
//  Created by Valentin Radu on 04/03/2023.
//

import AsyncAlgorithms
import Foundation
import Network
import os

public enum PeerTunnelError: Error {
    case failToEstablishConnection
}

public class PeerConnection {
    private let _connection: NWConnection
    private let _logger: Logger
    private let _messageChannel: AsyncChannel<Data>

    fileprivate init(to endpoint: NWEndpoint) {
        let parameters = NWParameters.tls
        parameters.includePeerToPeer = true
        let connection = NWConnection(to: endpoint, using: parameters)

        _connection = connection
        _logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "peerTunnel")
        _messageChannel = AsyncChannel()

        connection.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._connectionStateUpdateHandler(newState: newState)
        }
    }

    fileprivate init(rawConnection: NWConnection) {
        _connection = rawConnection
        _logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "peerTunnel")
        _messageChannel = AsyncChannel()
    }

    public func send<V>(value: V) throws where V: Codable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        _connection.send(content: data, completion: .idempotent)
    }

    public func readMessages<M>(as: M.Type) -> some AsyncSequence where M: Decodable {
        _messageChannel
            .compactMap { data -> M? in
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(M.self, from: data) else {
                    assertionFailure()
                    return nil
                }
                return result
            }
    }

    private func _receiveNextMessage() {
        _connection.receiveMessage { content, context, isComplete, error in
            assert(isComplete)

            if let content {
                print(content.count)
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

public class PeerBrowser {
    private let _browser: NWBrowser
    private let _logger: Logger
    private let _target: String
    private let _connectionChannel: AsyncThrowingChannel<PeerConnection, Error>

    init(target: String) {
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        let serviceDescriptor: NWBrowser.Descriptor = .bonjour(type: "_peertunnel._tcp", domain: nil)
        _browser = NWBrowser(for: serviceDescriptor, using: parameters)
        _logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "peerTunnel")
        _target = target
        _connectionChannel = AsyncThrowingChannel()
    }

    func findPeer() async throws -> PeerConnection {
        defer {
            _browser.cancel()
        }

        _browser.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }
            self._browserStateUpdateHandler(newState: newState)
        }

        _browser.browseResultsChangedHandler = { [weak self] _, _ in
            guard let self else { return }
            self._refreshResults()
        }

        _browser.start(queue: .main)

        for try await connection in _connectionChannel {
            return connection
        }

        throw PeerTunnelError.failToEstablishConnection
    }

    private func _browserStateUpdateHandler(newState: NWBrowser.State) {
        switch newState {
        case let .failed(error):
            _logger.fault("Peer browser failed with \(error), stopping")
            assertionFailure(error.debugDescription)
            _connectionChannel.fail(error)
        case .ready:
            _refreshResults()
        default:
            break
        }
    }

    private func _refreshResults() {
        for result in _browser.browseResults {
            switch result.endpoint {
            case let .service(name, _, _, _):
                if name == _target {
                    let connection = PeerConnection(to: result.endpoint)
                    Task {
                        await _connectionChannel.send(connection)
                    }
                }
            default:
                break
            }
        }
    }
}

public class PeerListener {
    private let _listener: NWListener
    private let _logger: Logger
    private let _connectionChannel: AsyncThrowingChannel<PeerConnection, Error>

    public init(name: String) throws {
        let parameters = NWParameters.tls
        parameters.includePeerToPeer = true
        let listener = try NWListener(using: parameters)

        _listener = listener
        listener.service = NWListener.Service(name: name, type: "_peertunnel._tcp")
        _logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "peerTunnel")
        _connectionChannel = AsyncThrowingChannel()
    }

    public func waitForPeer() async throws -> PeerConnection {
        defer {
            _listener.cancel()
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

        for try await connection in _connectionChannel {
            return connection
        }

        throw PeerTunnelError.failToEstablishConnection
    }

    private func _listenerStateUpdateHandler(newState: NWListener.State) {
        switch newState {
        case .ready:
            let portDebugDescription = _listener.port?.debugDescription ?? "unknown port"
            _logger.info("Listener ready on \(portDebugDescription)")
        case let .failed(error):
            _logger.fault("Listener failed with \(error), stopping")
            assertionFailure(error.debugDescription)
            _connectionChannel.fail(error)
        default:
            break
        }
    }

    private func _listenerNewConnectionHandler(newConnection: NWConnection) {
        Task {
            let connection = PeerConnection(rawConnection: newConnection)
            await _connectionChannel.send(connection)
        }
    }
}
