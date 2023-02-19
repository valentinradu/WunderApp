//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppService

extension Onboarding {
    struct FragmentView: View {
        private let _formActivityName: String = "com.wonderapp.activity.onboarding.form"
        private let _pathActivityName: String = "com.wonderapp.activity.onboarding.path"

        @Binding var state: ModelState
        let fragment: FragmentName

        var body: some View {
            let model = Model(state: $state, validatorService: ValidatorService())
            let action = Action(model: model)

            switch fragment {
            case .main:
                NavigationStack(path: $state.path) {
                    FragmentView(state: $state, fragment: .welcome)
                        .navigationDestination(for: FragmentName.self) { fragment in
                            FragmentView(state: $state, fragment: fragment)
                                .toolbar {
                                    EmptyView()
                                }
                        }
                }
            case .welcome:
                WelcomeView(page: $state.welcomePage,
                            outlet: action.welcomeOutlet)
            case .askEmail:
                AskEmailView(email: $state.form.email,
                             canMoveToNextStep: model.canPresent(fragment: .newAccount),
                             outlet: action.askEmailOutlet)
            case .askPassword:
                AskPasswordView(password: $state.form.password,
                                canMoveToNextStep: model.canLogin,
                                outlet: action.askPasswordOutlet)
            case .newAccount:
                NewAccountView(fullName: $state.form.fullName,
                               newPassword: $state.form.newPassword)
            case .locateUser:
                LocateAccountView(outlet: action.locateMeOutlet)
            case .suggestions:
                EmptyView()
            }
        }
    }
}
