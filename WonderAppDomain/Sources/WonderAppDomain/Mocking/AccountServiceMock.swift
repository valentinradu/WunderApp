//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import WonderAppExtensions

public extension UserProfile {
    static let mocked: UserProfile = .init(id: .init("0"), name: "John Appleseed")
}

public struct AccountServiceMock: Codable, AccountServiceProtocol {
    public var getUserProfileResult: MockedResult<UserProfile, ServiceError> = .success(value: .mocked, after: 0)

    public init() {}

    public func getUserProfile() async throws -> UserProfile {
        try await getUserProfileResult.unwrap()
    }
}
