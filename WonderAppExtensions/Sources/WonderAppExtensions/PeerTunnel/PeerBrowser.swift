//
//  File.swift
//
//
//  Created by Valentin Radu on 05/03/2023.
//

import Foundation
import Network
import os

public enum PeerBrowserError: Error {
    case alreadyDiscoveringPeers
}

public actor PeerBrowser {
    private let _logger: Logger = .init(subsystem: "com.peertunnel", category: "peer-browser")
    private let _browser: NWBrowser
    private let _target: String
    private var _connection: PeerConnection?
    private var _connectionContinuation: CheckedContinuation<PeerConnection, Error>?

    public init(target: String) {
        let parameters = NWParameters()
        let serviceDescriptor: NWBrowser.Descriptor = .bonjour(type: "_peertunnel._tcp", domain: nil)
        _browser = NWBrowser(for: serviceDescriptor, using: parameters)
        _target = target
    }

    public func discover() throws {
        if _browser.state != .setup {
            throw PeerBrowserError.alreadyDiscoveringPeers
        }

        _browser.stateUpdateHandler = { [weak self] newState in
            Task { [weak self] in
                guard let self else { return }
                await self._rawBrowserStateUpdateHandler(newState: newState)
            }
        }

        _browser.browseResultsChangedHandler = { [weak self] _, _ in
            Task { [weak self] in
                guard let self else { return }
                await self._refreshResults()
            }
        }

        _browser.start(queue: .main)
    }

    public func waitForConnection() async throws -> PeerConnection {
        if let connection = _connection {
            return connection
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

        _connection = result
        return result
    }

    private func _rawBrowserStateUpdateHandler(newState: NWBrowser.State) {
        switch newState {
        case let .failed(error):
            _logger.fault("Peer browser failed with \(error), stopping")
            assertionFailure(error.debugDescription)
            _connectionContinuation?.resume(throwing: error)
            _browser.cancel()
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
                if name == _target, _connection == nil {
                    let connection = PeerConnection(to: result.endpoint)
                    _connectionContinuation?.resume(returning: connection)
                    _connectionContinuation = nil
                    _connection = connection
                }
            default:
                break
            }
        }
    }
}
