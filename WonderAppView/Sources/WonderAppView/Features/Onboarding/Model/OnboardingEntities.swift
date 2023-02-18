//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import Foundation

extension Onboarding {
    enum Fragment: Codable, Hashable {
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

    enum FormFieldStatus: Codable, RawRepresentable {
        case idle
        case loading
        case failure(message: String? = nil)
        case success(message: String? = nil)
    }

    struct FormField {
        var value: String
        var status: FormFieldStatus

        static let empty: FormField = .init(value: "", status: .idle)
    }

    struct FormSecureField {
        var value: String
        var status: FormFieldStatus
        var isRevealed: Bool

        static let empty: FormSecureField = .init(value: "", status: .idle, isRevealed: false)
    }

    struct Form {
        var email: FormField
        var fullName: FormField
        var password: FormSecureField
        var newPassword: FormSecureField
        var focus: FormFieldName?
    }

    struct ModelState {
        var form: Form
        var path: [Fragment]
        var welcomePage: Int

        init(form: Form,
             path: [Fragment],
             welcomePage: Int) {
            self.form = form
            self.path = path
            self.welcomePage = welcomePage
        }
    }

    struct PersistentModelState: Codable {
        let email: String
        let fullName: String
        let path: [Fragment]
        let welcomePage: Int
        let focus: FormFieldName?
    }
}

extension Onboarding.FormFieldStatus {
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

extension Onboarding.ModelState {
    static let initial: Onboarding.ModelState = .init(form: .init(email: .empty,
                                                                  fullName: .empty,
                                                                  password: .empty,
                                                                  newPassword: .empty,
                                                                  focus: nil),
                                                      path: .init(),
                                                      welcomePage: 0)
}
