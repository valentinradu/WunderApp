//
//  File.swift
//
//
//  Created by Valentin Radu on 07/03/2023.
//

import Foundation
import PeerTunnel

public enum RemoteMockingMessage: UInt32, PeerMessageKindProtocol {
    case accountService
    case authService
    case guestService
    case placesService
}

private struct RemoteMockingServiceKey: ServiceKey {
    static var defaultValue: RemoteMockingService = .init()
}

public extension Service.Repository {
    var mocking: RemoteMockingService {
        nonmutating set { self[RemoteMockingServiceKey.self] = newValue }
        get { self[RemoteMockingServiceKey.self] }
    }
}

public actor RemoteMockingService {
    private var _clamant: PeerClamant<RemoteMockingMessage>?

    public func awaitMocks() async throws {
        let suppliant = PeerSuppliant<RemoteMockingMessage>(targetService: "remote-mocking", password: "unsecurepass")

        await suppliant.discover()
        let connection = try await suppliant.waitForConnection()
        let repository = ServiceRepository()

        for await message in connection.messages.values {
            let decoder = JSONDecoder()

            switch message.kind {
            case .accountService:
                repository.account = try decoder.decode(AccountServiceMock.self, from: message.data)
            case .authService:
                repository.auth = try decoder.decode(AuthServiceMock.self, from: message.data)
            case .guestService:
                repository.guest = try decoder.decode(GuestServiceMock.self, from: message.data)
            case .placesService:
                repository.places = try decoder.decode(PlacesServiceMock.self, from: message.data)
            }
        }
    }

    public func prepare() async throws {
        if _clamant == nil {
            let clamant = try PeerClamant<RemoteMockingMessage>(serviceName: "remote-mocking", password: "unsecurepass")
            await clamant.listen()
            _clamant = clamant
        }
    }

    public func mock<V>(service: RemoteMockingMessage, value: V) async throws where V: Codable {
        guard let clamant = _clamant else {
            assertionFailure()
            return
        }

        let connection = try await clamant.waitForConnection()
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        connection.send(messageKind: .accountService, data: data)
    }
}
