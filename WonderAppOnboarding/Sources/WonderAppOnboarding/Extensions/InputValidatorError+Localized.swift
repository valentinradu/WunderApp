//
//  InputValidatorError.swift
//  WonderApp
//
//  Created by Valentin Radu on 13/03/2023.
//

import WonderAppExtensions

public extension InputValidatorError {
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return .l10n.errorInvalidEmail
        case .missingEmail:
            return .l10n.errorMissingEmail
        case .missingName:
            return .l10n.errorMissingName
        case .passwordLengthFailure:
            return .l10n.errorPasswordLengthFailure
        case .passwordUppercaseFailure:
            return .l10n.errorPasswordUppercaseFailure
        }
    }
}
