//
//  File.swift
//
//
//  Created by Valentin Radu on 18/02/2023.
//

import SwiftUI

extension Onboarding {
    struct FragmentView: View {
        private let _formActivityName: String = "com.wonderapp.activity.onboarding.form"
        private let _pathActivityName: String = "com.wonderapp.activity.onboarding.path"

        @Binding var state: ModelState
        let fragment: Fragment

        var body: some View {
            let model = Model(state: $state, validatorService: ValidatorService())
            let viewModel = ViewModel(model: model)

            switch fragment {
            case .main:
                NavigationStack(path: $state.path) {
                    FragmentView(state: $state, fragment: .welcome)
                        .navigationDestination(for: Fragment.self) { fragment in
                            FragmentView(state: $state, fragment: fragment)
                                .toolbar {
                                    EmptyView()
                                }
                        }
                }
            case .welcome:
                WelcomeView(page: $state.welcomePage,
                            outlet: viewModel.welcomeOutlet)
            case .askEmail:
                AskEmailView(email: $state.form.email,
                             canMoveToNextStep: model.canPresent(fragment: .newAccount),
                             outlet: viewModel.askEmailOutlet)
            case .askPassword:
                AskPasswordView(password: $state.form.password,
                                canMoveToNextStep: model.canLogin,
                                outlet: viewModel.askPasswordOutlet)
            case .newAccount:
                NewAccountView(fullName: $state.form.fullName,
                               newPassword: $state.form.newPassword)
            case .locateUser:
                LocateAccountView(outlet: viewModel.locateMeOutlet)
            case .suggestions:
                EmptyView()
            }
        }
    }
}
