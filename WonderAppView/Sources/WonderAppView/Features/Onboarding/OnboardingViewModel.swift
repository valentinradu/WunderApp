//
//  File.swift
//
//
//  Created by Valentin Radu on 16/02/2023.
//

import SwiftUI

struct OnboardingViewModel {
    let model: OnboardingModel

    func onAppear(fragment: OnboardingFragment) {}

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
        Outlet {
            model.advance(towards: .askEmail)
        }
    }
}

struct OnboardingFragmentView: View {
    private let _onboardingFormActivityName: String = "com.wonderapp.activity.form"
    private let _onboardingPathActivityName: String = "com.wonderapp.activity.path"

    @Binding var state: OnboardingState
    let fragment: OnboardingFragment

    var body: some View {
        let model = OnboardingModel(state: $state, validator: ValidatorService())
        let viewModel = OnboardingViewModel(model: model)

        switch fragment {
        case .main:
            NavigationStack(path: $state.path) {
                OnboardingFragmentView(state: $state, fragment: .welcome)
                    .navigationDestination(for: OnboardingFragment.self) { fragment in
                        OnboardingFragmentView(state: $state, fragment: fragment)
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
