//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import Foundation
import SwiftUI
import WonderAppDomain
import WonderAppExtensions

enum FragmentName: Codable, Hashable {
    case main
    case welcome
    case askEmail
    case askPassword
    case newAccount
    case locateUser
    case suggestions
}

enum FormFieldName: Codable, Hashable, CaseIterable {
    case email
    case fullName
    case password
    case newPassword
}

enum ButtonName {
    case towardsAskEmail
    case towardsAskPassword
    case logInButton
    case signUpButton
    case locateMeButton
    case skipLocateMeButton
    case towardsSignUpButton
    case towardsLogInButton
}

struct FormFieldViewModel {
    var value: String {
        didSet {
            validateContinuously()
        }
    }

    var status: ControlStatus
    var isRedacted: Bool
    fileprivate var validator: (String) -> InputValidatorError?

    init(
        value: String = "",
        status: ControlStatus = .idle,
        isRedacted: Bool = false,
        validator: @escaping (String) -> InputValidatorError? = { _ in nil }
    ) {
        self.value = value
        self.status = status
        self.isRedacted = isRedacted
        self.validator = validator
    }

    mutating func validate() {
        guard !value.isEmpty else { return }
        if let error = validator(value) {
            status = .failure(message: error.localizedDescription)
        } else {
            status = .success()
        }
    }

    private mutating func validateContinuously() {
        let error = validator(value)
        if let error {
            if status != .idle {
                status = .failure(message: error.localizedDescription)
            }
        } else {
            status = .success()
        }
    }
}

struct FormViewModel {
    var email: FormFieldViewModel
    var fullName: FormFieldViewModel
    var password: FormFieldViewModel
    var newPassword: FormFieldViewModel
    var focus: FormFieldName? {
        didSet {
            if let oldValue, oldValue != focus {
                let keyPath = keyPath(for: oldValue)
                if !self[keyPath: keyPath].value.isEmpty {
                    self[keyPath: keyPath].validate()
                }
            }
        }
    }

    init(email: FormFieldViewModel = .init(),
         fullName: FormFieldViewModel = .init(),
         password: FormFieldViewModel = .init(),
         newPassword: FormFieldViewModel = .init(),
         focus: FormFieldName? = nil) {
        self.email = email
        self.fullName = fullName
        self.password = password
        self.newPassword = newPassword
        self.focus = focus

        let inputValidator = InputValidator()
        self.email.validator = inputValidator.validate(email:)
        self.fullName.validator = inputValidator.validate(name:)
        self.newPassword.validator = inputValidator.validate(password:)
    }

    func keyPath(for fieldName: FormFieldName) -> WritableKeyPath<Self, FormFieldViewModel> {
        switch fieldName {
        case .email:
            return \.email
        case .fullName:
            return \.fullName
        case .password:
            return \.password
        case .newPassword:
            return \.newPassword
        }
    }

    var areLogInCredentialsValid: Bool {
        email.status.isSuccess && !password.value.isEmpty
    }

    var areSignUpCredentialsValid: Bool {
        fullName.status.isSuccess && newPassword.status.isSuccess
    }

    fileprivate mutating func validate() {
        email.validate()
        fullName.validate()
        newPassword.validate()
    }
}

struct PersistentOnboardingViewModel: Codable, Sendable, Hashable {
    let email: String
    let fullName: String
    let path: [FragmentName]
    let welcomePage: Int
    let focus: FormFieldName?
}

private struct OnboardingViewModelStorageQuery: KeyValueStorageQuery {
    typealias Value = PersistentOnboardingViewModel
    private(set) var trait: KeyValueStorageQueryTrait = .heavyweight
    private(set) var key: String = "Onboarding.viewmodel"
}

private extension KeyValueStorageQuery where Self == OnboardingViewModelStorageQuery {
    static var onboardingViewModel: OnboardingViewModelStorageQuery { OnboardingViewModelStorageQuery() }
}
