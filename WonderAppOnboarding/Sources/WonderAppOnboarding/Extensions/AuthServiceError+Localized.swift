//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import WonderAppDomain

extension AuthServiceError {
    var localizedDescription: String {
        switch self {
        case .wrongEmailOrPassword:
            return .l10n.errorWrongEmailOrPassword
        case .invalidSignUpFields:
            return .l10n.errorInvalidSignUpFields
        case .unauthenticated:
            return .l10n.errorGeneric
        }
    }
}
