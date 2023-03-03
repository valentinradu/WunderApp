//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation

public struct UserProfile {
    public struct ID: Equatable {
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

public protocol AccountServiceProtocol {
    func getUserProfile() async throws -> UserProfile
}

public actor AccountService: AccountServiceProtocol {
    public func getUserProfile() async throws -> UserProfile {
        fatalError("Not implemented")
    }
}

public actor AccountServiceSample: AccountServiceProtocol {
    public var shouldFailWithError: Error?

    public func getUserProfile() async throws -> UserProfile {
        if let error = shouldFailWithError {
            throw error
        } else {
            return UserProfile(id: .init("0"), name: "John Appleseed")
        }
    }
}
