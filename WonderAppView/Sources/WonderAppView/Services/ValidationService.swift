//
//  File.swift
//
//
//  Created by Valentin Radu on 10/02/2023.
//

import SwiftUI

enum ValidationError: Error {
    case invalidEmail
    case missingEmail
    case missingName
    case passwordLengthFailure
    case passwordUppercaseFailure
}

struct ValidatorService {
    func validate(email: String) -> ValidationError? {
        guard !email.isEmpty else {
            return ValidationError.missingEmail
        }

        let regex = #/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/#
        guard email.wholeMatch(of: regex) != nil else {
            return ValidationError.invalidEmail
        }

        return nil
    }

    func validate(name: String) -> ValidationError? {
        guard !name.isEmpty else {
            return ValidationError.missingName
        }

        return nil
    }

    func validate(password: String) -> ValidationError? {
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
