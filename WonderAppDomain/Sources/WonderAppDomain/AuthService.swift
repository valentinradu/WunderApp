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
    var auth: AuthServiceProtocol {
        set { self[AuthServiceKey.self] = newValue }
        get { self[AuthServiceKey.self] }
    }
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
