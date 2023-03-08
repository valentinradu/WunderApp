//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation

public struct UserProfile: Codable, Sendable {
    public struct ID: Codable, Sendable, Equatable {
        private let _rawValue: String
        public init(_ rawValue: String) {
            _rawValue = rawValue
        }
    }

    public let id: ID
    public let name: String
}

public struct AccountServiceKey: ServiceKey {
    public static var defaultValue: AccountServiceProtocol = AccountService()
}

public extension Service.Repository {
    var account: AccountServiceProtocol {
        nonmutating set { self[AccountServiceKey.self] = newValue }
        get { self[AccountServiceKey.self] }
    }
}

public protocol AccountServiceProtocol {
    func getUserProfile() async throws -> UserProfile
    func locate() async throws
}

private actor AccountService: AccountServiceProtocol {
    public func getUserProfile() async throws -> UserProfile {
        fatalError("Not implemented")
    }

    public func locate() async throws {
        fatalError("Not implemented")
    }
}
