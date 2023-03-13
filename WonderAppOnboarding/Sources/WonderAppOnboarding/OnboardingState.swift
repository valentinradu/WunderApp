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

enum TaskName {
    case saveState
    case restoreState
    case logIn
    case signUp
}

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

struct FormState: Hashable {
    var emailField: FormFieldModel
    var fullNameField: FormFieldModel
    var passwordField: FormFieldModel
    var newPasswordField: FormFieldModel
    var toNewAccountControl: FormControlModel
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

    init(emailField: FormFieldModel = .init(),
         fullNameField: FormFieldModel = .init(),
         passwordField: FormFieldModel = .init(),
         newPasswordField: FormFieldModel = .init(),
         toNewAccountControl: FormControlModel = .init(),
         focus: FormFieldName? = nil) {
        self.emailField = emailField
        self.fullNameField = fullNameField
        self.passwordField = passwordField
        self.newPasswordField = newPasswordField
        self.toNewAccountControl = toNewAccountControl
        self.focus = focus

        let formFieldValidator = FormFieldValidator()
        self.emailField.validator = formFieldValidator.validate(email:)
        self.fullNameField.validator = formFieldValidator.validate(name:)
        self.newPasswordField.validator = formFieldValidator.validate(password:)
    }

    func keyPath(for fieldName: FormFieldName) -> WritableKeyPath<Self, FormFieldModel> {
        switch fieldName {
        case .email:
            return \.emailField
        case .fullName:
            return \.fullNameField
        case .password:
            return \.passwordField
        case .newPassword:
            return \.newPasswordField
        }
    }

    var areLogInCredentialsValid: Bool {
        emailField.status.isSuccess && !passwordField.value.isEmpty
    }

    var areSignUpCredentialsValid: Bool {
        fullNameField.status.isSuccess && newPasswordField.status.isSuccess
    }

    mutating func validate() {
        emailField.validate()
        fullNameField.validate()
        newPasswordField.validate()
    }
}

extension FormState: Codable {
    enum CodingKeys: CodingKey {
        case email
        case password
        case newPassword
        case fullName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let email = try container.decode(String.self, forKey: .email)
        let password = try container.decode(String.self, forKey: .password)
        let newPassword = try container.decode(String.self, forKey: .newPassword)
        let fullName = try container.decode(String.self, forKey: .fullName)

        let emailField = FormFieldModel(value: email)
        let fullNameField = FormFieldModel(value: fullName)
        let passwordField = FormFieldModel(value: password)
        let newPasswordField = FormFieldModel(value: newPassword)

        self = FormState(emailField: emailField,
                         fullNameField: fullNameField,
                         passwordField: passwordField,
                         newPasswordField: newPasswordField)
        validate()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(emailField.value, forKey: .email)
        try container.encode(passwordField.value, forKey: .password)
        try container.encode(newPasswordField.value, forKey: .newPassword)
        try container.encode(fullNameField.value, forKey: .fullName)
    }
}
