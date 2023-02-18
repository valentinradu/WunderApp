//
//  File.swift
//
//
//  Created by Valentin Radu on 16/02/2023.
//

import Foundation
import SwiftUI

extension Onboarding {
    enum OnboardingFragment: Codable, Hashable {
        case main
        case welcome
        case askEmail
        case askPassword
        case newAccount
        case locateUser
        case suggestions
    }
}

enum OnboardingFragment: Codable, Hashable {
    case main
    case welcome
    case askEmail
    case askPassword
    case newAccount
    case locateUser
    case suggestions
}

enum OnboardingFormFieldName: Codable, Hashable {
    case email
    case fullName
    case password
    case newPassword
}

struct OnboardingFormFieldState {
    var value: String
    var status: OnboardingFormFieldStatus

    static let empty: OnboardingFormFieldState = .init(value: "", status: .idle)
}

struct OnboardingFormSecureFieldState {
    var value: String
    var status: OnboardingFormFieldStatus
    var isRevealed: Bool

    static let empty: OnboardingFormSecureFieldState = .init(value: "", status: .idle, isRevealed: false)
}

struct OnboardingFormState {
    var email: OnboardingFormFieldState
    var fullName: OnboardingFormFieldState
    var password: OnboardingFormSecureFieldState
    var newPassword: OnboardingFormSecureFieldState
    var focus: OnboardingFormFieldName?
}

struct OnboardingState {
    var form: OnboardingFormState
    var path: [OnboardingFragment]
    var welcomePage: Int

    init(form: OnboardingFormState,
         path: [OnboardingFragment],
         welcomePage: Int) {
        self.form = form
        self.path = path
        self.welcomePage = welcomePage
    }
}

struct PersistentOnboardingState: Codable {
    let email: String
    let fullName: String
    let path: [OnboardingFragment]
    let welcomePage: Int
    let focus: OnboardingFormFieldName?
}

extension OnboardingFormFieldStatus {
    init(value: String, validator: (String) -> Error?) {
        if value.isEmpty {
            self = .idle
        } else if let error = validator(value) {
            self = .failure(message: error.localizedDescription)
        } else {
            self = .success()
        }
    }
}

struct OnboardingModel {
    @Binding var state: OnboardingState
    let validator: ValidatorService

    func save(to activity: NSUserActivity) {
        let persistentState = PersistentOnboardingState(email: state.form.email.value,
                                                        fullName: state.form.fullName.value,
                                                        path: state.path,
                                                        welcomePage: state.welcomePage,
                                                        focus: state.form.focus)
        activity.isEligibleForHandoff = true
        do {
            try activity.setTypedPayload(persistentState)
        } catch {
            // TODO: Log this
        }
    }

    func restore(from activity: NSUserActivity) {
        do {
            let persistentState = try activity.typedPayload(PersistentOnboardingState.self)
            state.form.email = .init(value: persistentState.email,
                                     status: .init(value: persistentState.email,
                                                   validator: validator.validate(email:)))
            state.form.fullName = .init(value: persistentState.fullName,
                                        status: .init(value: persistentState.fullName,
                                                      validator: validator.validate(name:)))
            state.path = persistentState.path
            state.welcomePage = persistentState.welcomePage
            state.form.focus = persistentState.focus
        } catch {
            // TODO: Log this
        }
    }

    func advance(towards fragment: OnboardingFragment) {
        switch fragment {
        case .askEmail:
            if state.welcomePage < 2 {
                state.welcomePage += 1
            } else {
                state.path.append(fragment)
            }
        default:
            state.path.append(fragment)
        }
    }

    func canPresent(fragment: OnboardingFragment) -> Bool { true }

    var canLogin: Bool {
        switch (state.form.email.status, state.form.password.status) {
        case (.success, .success):
            return true
        default:
            return false
        }
    }
}
