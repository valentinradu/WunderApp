//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import Foundation

private struct AuthServiceKey: ServiceKey {
    public static var defaultValue: AuthServiceProtocol = AuthService()
}

public extension Service.Repository {
    var authService: AuthServiceProtocol {
        set { self[AuthServiceKey.self] = newValue }
        get { self[AuthServiceKey.self] }
    }
}

public enum AuthServiceError: Error {
    case wrongEmailOrPassword
    case invalidSignUpFields
    case unauthenticated
}

public protocol AuthServiceProtocol {
    func logIn(email: String, password: String) async throws
    func logOut() async throws
    func signUp(fullName: String, newPassword: String) async throws
}

public actor AuthService: AuthServiceProtocol {
    public func logIn(email: String, password: String) async throws {
        fatalError("Not implemented")
    }

    public func logOut() async throws {
        fatalError("Not implemented")
    }

    public func signUp(fullName: String, newPassword: String) async throws {
        fatalError("Not implemented")
    }
}

public actor AuthServiceSample: AuthServiceProtocol {
    @Service(\.keyValueStorage) private var _keyValueStorage

    public func logIn(email: String, password: String) async throws {
        if password.starts(with: "wrong") {
            throw AuthServiceError.wrongEmailOrPassword
        }
    }

    public func logOut() async throws {}

    public func signUp(fullName: String, newPassword: String) async throws {
        if newPassword.starts(with: "wrong") {
            throw AuthServiceError.invalidSignUpFields
        }
    }
}
