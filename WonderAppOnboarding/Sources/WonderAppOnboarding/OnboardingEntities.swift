//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import Foundation
import WonderAppExtensions

extension Onboarding {
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

        static let empty: FormFieldState = .init(value: "", status: .idle)
    }

    struct FormSecureFieldState {
        var value: String
        var status: ControlStatus
        var isRevealed: Bool

        static let empty: FormSecureFieldState = .init(value: "", status: .idle, isRevealed: false)
    }

    struct FormState {
        var email: FormFieldState
        var fullName: FormFieldState
        var password: FormSecureFieldState
        var newPassword: FormSecureFieldState
        var focus: FormFieldName?
    }

    struct ModelState {
        var form: FormState
        var path: [FragmentName]
        var welcomePage: Int

        init(form: FormState,
             path: [FragmentName],
             welcomePage: Int) {
            self.form = form
            self.path = path
            self.welcomePage = welcomePage
        }
    }

    struct PersistentModelState: Codable {
        let email: String
        let fullName: String
        let path: [FragmentName]
        let welcomePage: Int
        let focus: FormFieldName?
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
