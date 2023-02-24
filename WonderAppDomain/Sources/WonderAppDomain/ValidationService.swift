//
//  File.swift
//
//
//  Created by Valentin Radu on 10/02/2023.
//

import SwiftUI

public enum ValidationError: Error {
    case invalidEmail
    case missingEmail
    case missingName
    case passwordLengthFailure
    case passwordUppercaseFailure
}

private struct ValidationServiceKey: ServiceKey {
    static var defaultValue: ValidationService = .init()
}

public extension Service.Repository {
    var validationService: ValidationService {
        get { self[ValidationServiceKey.self] }
        set { self[ValidationServiceKey.self] = newValue }
    }
}

public protocol ValidationServiceProtocol {
    func validate(email: String) -> ValidationError?
    func validate(name: String) -> ValidationError?
    func validate(password: String) -> ValidationError?
}

public struct ValidationService: ValidationServiceProtocol {
    public init() {}

    public func validate(email: String) -> ValidationError? {
        guard !email.isEmpty else {
            return ValidationError.missingEmail
        }

        let regex = #/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/#
        guard email.wholeMatch(of: regex) != nil else {
            return ValidationError.invalidEmail
        }

        return nil
    }

    public func validate(name: String) -> ValidationError? {
        guard !name.isEmpty else {
            return ValidationError.missingName
        }

        return nil
    }

    public func validate(password: String) -> ValidationError? {
        guard password.count >= 8 else {
            return ValidationError.passwordLengthFailure
        }

        var hasUpperCase = false

        for char in password {
            if char.isUppercase {
                hasUpperCase = true
                break
            }
        }

        guard hasUpperCase else {
            return ValidationError.passwordUppercaseFailure
        }

        return nil
    }
}
