//
//  File.swift
//
//
//  Created by Valentin Radu on 11/02/2023.
//

import Foundation

extension ValidationError {
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
