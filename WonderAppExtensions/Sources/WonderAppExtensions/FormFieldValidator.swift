//
//  File.swift
//
//
//  Created by Valentin Radu on 27/02/2023.
//

import Foundation

public enum InputValidatorError: Error {
    case invalidEmail
    case missingEmail
    case missingName
    case passwordLengthFailure
    case passwordUppercaseFailure
}

public struct FormFieldValidator {
    public init() {}

    public func validate(email: String) -> InputValidatorError? {
        guard !email.isEmpty else {
            return InputValidatorError.missingEmail
        }

        let regex = #/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/#.ignoresCase()
        guard email.wholeMatch(of: regex) != nil else {
            return InputValidatorError.invalidEmail
        }

        return nil
    }

    public func validate(name: String) -> InputValidatorError? {
        guard !name.isEmpty else {
            return InputValidatorError.missingName
        }

        return nil
    }

    public func validate(password: String) -> InputValidatorError? {
        guard password.count >= 8 else {
            return InputValidatorError.passwordLengthFailure
        }

        var hasUpperCase = false

        for char in password {
            if char.isUppercase {
                hasUpperCase = true
                break
            }
        }

        guard hasUpperCase else {
            return InputValidatorError.passwordUppercaseFailure
        }

        return nil
    }
}
