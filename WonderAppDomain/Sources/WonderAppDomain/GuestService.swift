//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import Foundation

private struct GuestServiceKey: ServiceKey {
    static var defaultValue: GuestServiceProtocol = GuestService()
}

public extension Service.Repository {
    var guestService: GuestServiceProtocol {
        set { self[GuestServiceKey.self] = newValue }
        get { self[GuestServiceKey.self] }
    }
}

public protocol GuestServiceProtocol {
    func isEmailAvailable(_ value: String) async throws -> Bool
}

public actor GuestService: GuestServiceProtocol {
    public func isEmailAvailable(_ value: String) async throws -> Bool {
        fatalError("Not implemented")
    }
}

public actor GuestServiceSample: GuestServiceProtocol {
    public func isEmailAvailable(_ value: String) async throws -> Bool {
        !value.starts(with: "unavailable")
    }
}
