//
//  File.swift
//
//
//  Created by Valentin Radu on 21/02/2023.
//

import Foundation
import SwiftUI
import WonderAppService

private struct OnboardingServiceEnvironmentKey: EnvironmentKey {
    static var defaultValue: OnboardingService = .empty()
}

extension EnvironmentValues {
    var onboardingService: OnboardingService {
        get { self[OnboardingServiceEnvironmentKey.self] }
        set { self[OnboardingServiceEnvironmentKey.self] = newValue }
    }
}

struct OnboardingService {
    typealias TextInputValidator = (String) -> Error?
    let validateEmail: TextInputValidator
    let validateName: TextInputValidator
    let validatePassword: TextInputValidator
}

extension OnboardingService {
    static func empty(validateEmail: TextInputValidator? = nil,
                      validateName: TextInputValidator? = nil,
                      validatePassword: TextInputValidator? = nil) -> OnboardingService {
        let validationService = ValidatorService()
        let validateEmail = validateEmail ?? validationService.validate(email:)
        let validateName = validateName ?? validationService.validate(name:)
        let validatePassword = validatePassword ?? validationService.validate(password:)
        return .init(validateEmail: validateEmail,
                     validateName: validateName,
                     validatePassword: validatePassword)
    }
}
