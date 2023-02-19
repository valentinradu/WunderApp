//
//  File.swift
//
//
//  Created by Valentin Radu on 16/02/2023.
//

import Foundation
import SwiftUI
import WonderAppService

extension Onboarding {
    struct Model {
        @Binding var state: ModelState
        let validatorService: ValidatorService

        func save(to activity: NSUserActivity) {
            let persistentState = PersistentModelState(email: state.form.email.value,
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
                let persistentState = try activity.typedPayload(PersistentModelState.self)
                state.form.email = .init(value: persistentState.email,
                                         status: .init(value: persistentState.email,
                                                       validator: validatorService.validate(email:)))
                state.form.fullName = .init(value: persistentState.fullName,
                                            status: .init(value: persistentState.fullName,
                                                          validator: validatorService.validate(name:)))
                state.path = persistentState.path
                state.welcomePage = persistentState.welcomePage
                state.form.focus = persistentState.focus
            } catch {
                // TODO: Log this
            }
        }

        func advance(towards fragment: FragmentName) {
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

        func canPresent(fragment: FragmentName) -> Bool { true }

        var canLogin: Bool {
            switch (state.form.email.status, state.form.password.status) {
            case (.success, .success):
                return true
            default:
                return false
            }
        }
    }
}
