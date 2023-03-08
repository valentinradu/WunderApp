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

private enum OnboardingViewModelTask {
    case save
    case logIn
    case logOut
    case signUp
    case locateAccount
}

@MainActor
public final class OnboardingViewModel: ObservableObject {
    @Published var form: FormViewModel = .init() {
        didSet {
            _onPersistentFieldChange()
        }
    }

    @Published var path: [FragmentName] = [] {
        didSet {
            _onPersistentFieldChange()
        }
    }

    @Published var welcomePage: Int = 0 {
        didSet {
            _onPersistentFieldChange()
        }
    }

    @Published var isReady: Bool = false
    @Published var toastMessage: String?

    private var _taskPlanner: TaskPlanner<OnboardingViewModelTask> = .init()
    @Service(\.keyValueStorage) private var _keyValueStorage
    @Service(\.auth) private var _authService
    @Service(\.account) private var _accountService

    public init() {}

    func onPostAppear(fragment: FragmentName) {
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
        case .towardsAskPassword:
            path.append(.askPassword)
        case .logInButton:
            _performLogIn()
        case .signUpButton:
            _performSignUp()
        case .locateMeButton:
            _taskPlanner.perform(.locateAccount) { [weak self] in
                guard let self = self else { return }
                try await self._accountService.locate()
                self.path.append(.suggestions)
            }
        case .skipLocateMeButton:
            path.append(.suggestions)
        case .towardsSignUpButton:
            path.append(.newAccount)
        case .towardsLogInButton:
            path.append(.askPassword)
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
                _performLogIn()
            }
        case .newPassword:
            if form.areSignUpCredentialsValid {
                _performSignUp()
            }
        }
    }

    func prepare() async {
        await _attemptToRestore()
        isReady = true
    }

    private func _onPersistentFieldChange() {
        _taskPlanner.perform(.save) { [weak self] in
            try await Task.sleep(for: .seconds(1))
            try Task.checkCancellation()
            await self?._save()
        }
    }

    private func _save() async {
        let persistentViewModel = PersistentOnboardingViewModel(email: form.email.value,
                                                                fullName: form.fullName.value,
                                                                path: path,
                                                                welcomePage: welcomePage,
                                                                focus: form.focus)
        do {
            try await _keyValueStorage.create(query: .onboardingViewModel, value: persistentViewModel)
        } catch {
            assertionFailure()
            // TODO: Log
        }
    }

    private func _attemptToRestore() async {
        guard let persistentViewModel = try? await _keyValueStorage.read(query: .onboardingViewModel) else {
            return
        }

        let validator = InputValidator()
        form.email = .init(value: persistentViewModel.email,
                           status: .idle,
                           isRedacted: false,
                           validator: validator.validate(email:))
        form.fullName = .init(value: persistentViewModel.fullName,
                              status: .idle,
                              isRedacted: false,
                              validator: validator.validate(name:))
        form.validate()

        path = persistentViewModel.path
        welcomePage = persistentViewModel.welcomePage
        form.focus = persistentViewModel.focus
    }

    private func _performLogIn() {
        _taskPlanner.perform(.logIn) { [unowned self] in
            do {
                try await _authService.logIn(email: form.email.value,
                                             password: form.email.value)
                path.append(.locateUser)
            } catch let error as ServiceError {
                toastMessage = error.localizedDescription
            } catch {
                toastMessage = .l10n.errorGeneric
            }
        }
    }

    private func _performSignUp() {
        _taskPlanner.perform(.signUp) { [unowned self] in
            do {
                try await _authService.signUp(fullName: form.fullName.value,
                                              newPassword: form.newPassword.value)
                path.append(.locateUser)
            } catch let error as ServiceError {
                toastMessage = error.localizedDescription
            } catch {
                toastMessage = .l10n.errorGeneric
            }
        }
    }
}
