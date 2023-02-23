//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import Foundation
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

enum FormFieldName: Codable, Hashable {
    case email
    case fullName
    case password
    case newPassword
}

struct FormFieldState {
    var value: String
    var status: ControlStatus
    var isRedacted: Bool
    var validator: (String) -> Error?

    static let empty: FormFieldState = .init(
        value: "",
        status: .idle,
        isRedacted: false,
        validator: { _ in nil }
    )

    mutating func validate() {
        if let error = validator(value) {
            status = .failure(message: error.localizedDescription)
        } else {
            status = .success()
        }
    }
}

struct FormState {
    var email: FormFieldState
    var fullName: FormFieldState
    var password: FormFieldState
    var newPassword: FormFieldState
    private(set) var focus: FormFieldName?

    private func keyPath(for fieldName: FormFieldName) -> WritableKeyPath<Self, FormFieldState> {
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

    mutating func focus(field: FormFieldName?) {
        if let currentFocusedField = field {
            self[keyPath: keyPath(for: currentFocusedField)].validate()
        }
        focus = field
    }
}

final class OnboardingState: ObservableObject {
    @Published var form: FormState
    @Published var path: [FragmentName]
    @Published var welcomePage: Int
    @Published var service: OnboardingService

    init(form: FormState,
         path: [FragmentName],
         welcomePage: Int,
         service: OnboardingService) {
        self.form = form
        self.path = path
        self.welcomePage = welcomePage
        self.service = service
    }

    var canLogin: Bool {
        let emailError = service.validateEmail(form.email.value)
        let passwordError = service.validatePassword(form.password.value)

        return emailError.isNil && passwordError.isNil
    }

    func canPresent(fragment: FragmentName) -> Bool {
        switch fragment {
        case .newAccount:
            let error = service.validateEmail(form.email.value)
            return error.isNil
        default:
            return true
        }
    }

    func onAppear(fragment: FragmentName) {
        switch fragment {
        case .main, .welcome, .locateUser, .suggestions:
            break
        case .askEmail:
            form.focus(field: .email)
        case .askPassword:
            form.focus(field: .password)
        case .newAccount:
            form.focus(field: .fullName)
        }
    }

    var askEmailOutlet: Outlet<Void> {
        .inactive()
    }

    var askPasswordOutlet: Outlet<AskPasswordControlName> {
        .inactive()
    }

    var locateMeOutlet: Outlet<LocateAccountControlName> {
        .inactive()
    }

    var welcomeOutlet: Outlet<Void> {
        Outlet { [weak self] in
            guard let self = self else { return }
            self.advance(towards: .askEmail)
        }
    }

    func save(to activity: NSUserActivity) {
        let persistentState = PersistentOnboardingState(email: form.email.value,
                                                        fullName: form.fullName.value,
                                                        path: path,
                                                        welcomePage: welcomePage,
                                                        focus: form.focus)
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
            form.email = .init(value: persistentState.email,
                               status: .idle,
                               isRedacted: false,
                               validator: service.validateEmail)
            form.fullName = .init(value: persistentState.fullName,
                                  status: .idle,
                                  isRedacted: false,
                                  validator: service.validateName)
            form.email.validate()
            form.fullName.validate()

            path = persistentState.path
            welcomePage = persistentState.welcomePage
            form.focus(field: persistentState.focus)
        } catch {
            // TODO: Log this
        }
    }

    func advance(towards fragment: FragmentName) {
        switch fragment {
        case .askEmail:
            if welcomePage < 2 {
                welcomePage += 1
            } else {
                path.append(fragment)
            }
        default:
            path.append(fragment)
        }
    }
}

struct PersistentOnboardingState: Codable {
    let email: String
    let fullName: String
    let path: [FragmentName]
    let welcomePage: Int
    let focus: FormFieldName?
}

extension OnboardingState {
    static let empty: OnboardingState = .init(form: .init(email: .empty,
                                                          fullName: .empty,
                                                          password: .empty,
                                                          newPassword: .empty,
                                                          focus: nil),
                                              path: .init(),
                                              welcomePage: 0,
                                              service: .empty())
}
