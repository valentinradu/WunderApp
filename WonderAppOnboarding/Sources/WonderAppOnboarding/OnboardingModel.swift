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

enum ButtonName {
    case towardsAskEmail
    case towardsAskPassword
    case towardsSuggestions
    case logInButton
    case signUpButton
    case locateMeButton
    case skipLocateMeButton
    case towardsSignUpButton
    case towardsLogInButton
}

struct FormFieldModel {
    var value: String {
        didSet {
            validateContinuously()
        }
    }

    var status: ControlStatus
    var isRedacted: Bool
    fileprivate var validator: (String) -> ValidationError?

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

    fileprivate mutating func validate(fieldName: FormFieldName) {
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

    fileprivate mutating func validate() {
        email.validate()
        fullName.validate()
        newPassword.validate()
    }

    var areLogInCredentialsValid: Bool {
        email.status.isSuccess && !password.value.isEmpty
    }

    var areSignUpCredentialsValid: Bool {
        fullName.status.isSuccess && newPassword.status.isSuccess
    }
}

struct PersistentOnboardingModel: Codable {
    let email: String
    let fullName: String
    let path: [FragmentName]
    let welcomePage: Int
    let focus: FormFieldName?
}

enum PersistentOnboardingUserActivity {
    static let model: String = "com.wonderapp.onboarding.activity.model"
}

final class OnboardingModel: ObservableObject {
    @Service(\.validationService) private var _validationService

    @Published var form: FormModel = .init()
    @Published var path: [FragmentName] = []
    @Published var welcomePage: Int = 0

    func canPresent(fragment: FragmentName) -> Bool {
        switch fragment {
        case .newAccount:
            return form.email.status.isSuccess
        default:
            return true
        }
    }

    func postAppear(fragment: FragmentName) {
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

    func onInteraction(button: ButtonName) {
        switch button {
        case .towardsAskEmail:
            if welcomePage < 2 {
                welcomePage += 1
            } else {
                path.append(.askEmail)
            }
        case .towardsSignUpButton:
            path.append(.newAccount)
        case .towardsLogInButton:
            path.append(.askPassword)
        default:
            break
        }
    }

    func onSubmit(formFieldName: FormFieldName) {
        switch formFieldName {
        case .email:
            form.email.validate()
            if form.email.status.isSuccess {
                path.append(.newAccount)
            }
        case .fullName:
            form.focus = .newPassword
        case .password:
            if form.areLogInCredentialsValid {
                // TODO: Log in
            }
        case .newPassword:
            if form.areSignUpCredentialsValid {
                // TODO: Sign up
            }
        }
    }

    func onUserActivity(_ activity: NSUserActivity) {
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
            assertionFailure()
        }
    }

    func onContinueUserActivity(_ activity: NSUserActivity) {
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
            form.focus = persistentModel.focus
        } catch {
            // TODO: Log this
            assertionFailure()
        }
    }
}
