//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import Foundation
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

struct FormFieldModel {
    var value: String {
        didSet {
            validateContinuously()
        }
    }

    var status: ControlStatus
    var isRedacted: Bool
    var validator: (String) -> ValidationError?

    init(
        value: String = "",
        status: ControlStatus = .idle,
        isRedacted: Bool = false,
        validator: @escaping (String) -> ValidationError? = { _ in nil }
    ) {
        self.value = value
        self.status = status
        self.isRedacted = isRedacted
        self.validator = validator
    }

    mutating func validate() {
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

struct FormModel {
    @Service(\.validationService) private var _validationService

    var email: FormFieldModel
    var fullName: FormFieldModel
    var password: FormFieldModel
    var newPassword: FormFieldModel
    var focus: FormFieldName?

    init(email: FormFieldModel = .init(),
         fullName: FormFieldModel = .init(),
         password: FormFieldModel = .init(),
         newPassword: FormFieldModel = .init(),
         focus: FormFieldName? = nil) {
        self.email = email
        self.fullName = fullName
        self.password = password
        self.newPassword = newPassword
        self.focus = focus

        self.email.validator = _validationService.validate(email:)
        self.fullName.validator = _validationService.validate(name:)
        self.newPassword.validator = _validationService.validate(password:)
    }

    private func keyPath(for fieldName: FormFieldName) -> WritableKeyPath<Self, FormFieldModel> {
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

    mutating func focus(fieldName: FormFieldName?) {
        if let focus, fieldName != focus {
            let keyPath = keyPath(for: focus)
            self[keyPath: keyPath].validate()
        }
        focus = fieldName
    }

    mutating func validate(fieldName: FormFieldName) {
        switch fieldName {
        case .email:
            email.validate()
        case .fullName:
            fullName.validate()
        case .password:
            break
        case .newPassword:
            newPassword.validate()
        }
    }

    mutating func validate() {
        email.validate()
        fullName.validate()
        newPassword.validate()
    }
}

final class OnboardingModel: ObservableObject {
    @Service(\.validationService) private var _validationService

    @Published var form: FormModel = .init()
    @Published var path: [FragmentName] = []
    @Published var welcomePage: Int = 0

    var canLogin: Bool {
        let emailError = _validationService.validate(email: form.email.value)
        let passwordError = _validationService.validate(password: form.password.value)

        return emailError.isNil && passwordError.isNil
    }

    var canSignUp: Bool {
        let fullNameError = _validationService.validate(name: form.fullName.value)
        let newPasswordError = _validationService.validate(password: form.newPassword.value)

        return fullNameError.isNil && newPasswordError.isNil
    }

    func canPresent(fragment: FragmentName) -> Bool {
        switch fragment {
        case .newAccount:
            let error = _validationService.validate(email: form.email.value)
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
            form.focus = .email
        case .askPassword:
            form.focus = .password
        case .newAccount:
            form.focus = .fullName
        }
    }

    var askEmailFragmentOutlet: Outlet<Void> {
        Outlet { [weak self] in
            guard let self = self else { return }
            self.advance(towards: .newAccount)
        }
    }

    var askPasswordFragmentOutlet: Outlet<AskPasswordControlName> {
        Outlet { [weak self] controlName in
            guard let self = self else { return }

            switch controlName {
            case .logInButton:
                break
            case .signUpButton:
                self.advance(towards: .newAccount)
            }
        }
    }

    var newAccountFragmentOutlet: Outlet<NewAccountControlName> {
        Outlet { [weak self] controlName in
            guard let self = self else { return }

            switch controlName {
            case .logInButton:
                self.advance(towards: .askPassword)
            case .signUpButton:
                break
            }
        }
    }

    var locateMeFragmentOutlet: Outlet<LocateAccountControlName> {
        .inactive()
    }

    var welcomeFragmentOutlet: Outlet<Void> {
        Outlet { [weak self] in
            guard let self = self else { return }
            self.advance(towards: .askEmail)
        }
    }

    func save(to activity: NSUserActivity) {
        let persistentModel = PersistentOnboardingModel(email: form.email.value,
                                                        fullName: form.fullName.value,
                                                        path: path,
                                                        welcomePage: welcomePage,
                                                        focus: form.focus)
        activity.isEligibleForHandoff = true
        do {
            try activity.setTypedPayload(persistentModel)
        } catch {
            // TODO: Log this
        }
    }

    func restore(from activity: NSUserActivity) {
        do {
            let persistentModel = try activity.typedPayload(PersistentOnboardingModel.self)
            form.email = .init(value: persistentModel.email,
                               status: .idle,
                               isRedacted: false,
                               validator: _validationService.validate(email:))
            form.fullName = .init(value: persistentModel.fullName,
                                  status: .idle,
                                  isRedacted: false,
                                  validator: _validationService.validate(name:))
            form.validate()

            path = persistentModel.path
            welcomePage = persistentModel.welcomePage
            form.focus(fieldName: persistentModel.focus)
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

struct PersistentOnboardingModel: Codable {
    let email: String
    let fullName: String
    let path: [FragmentName]
    let welcomePage: Int
    let focus: FormFieldName?
}
