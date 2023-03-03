//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation
import WonderAppExtensions

public struct AuthServiceMock: Codable, AuthServiceProtocol {
    public var logInResult: MockedEmptyResult<ServiceError> = .success(after: 0)
    public var logOutResult: MockedEmptyResult<ServiceError> = .success(after: 0)
    public var signUpResult: MockedEmptyResult<ServiceError> = .success(after: 0)

    public func logIn(email: String, password: String) async throws {
        try await logInResult.unwrap()
    }

    public func logOut() async throws {
        try await logOutResult.unwrap()
    }

    public func signUp(fullName: String, newPassword: String) async throws {
        try await signUpResult.unwrap()
    }
}
