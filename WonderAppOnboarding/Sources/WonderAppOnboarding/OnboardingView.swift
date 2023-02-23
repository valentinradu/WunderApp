//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppService

private struct OnboardingFragmentView: View {
    private let _formActivityName: String = "com.wonderapp.activity.onboarding.form"
    private let _pathActivityName: String = "com.wonderapp.activity.onboarding.path"
    @FocusState private var _focused: FormFieldName?
    @Environment(\.onboardingService) private var _onboardingService
    @ObservedObject var state: OnboardingState
    let fragment: FragmentName

    var body: some View {
        Group {
            switch fragment {
            case .main:
                OnboardingFragmentView(state: state, fragment: .welcome)
                    .navigationDestination(for: FragmentName.self) { fragment in
                        OnboardingFragmentView(state: state, fragment: fragment)
                            .toolbar {
                                EmptyView()
                            }
                    }
            case .welcome:
                WelcomeView(page: $state.welcomePage,
                            outlet: state.welcomeOutlet)
            case .askEmail:
                AskEmailView(email: $state.form.email,
                             canMoveToNextStep: state.canPresent(fragment: .newAccount),
                             outlet: state.askEmailOutlet)
                    .focused($_focused, equals: .email)
            case .askPassword:
                AskPasswordView(password: $state.form.password,
                                canMoveToNextStep: state.canLogin,
                                outlet: state.askPasswordOutlet)
                    .focused($_focused, equals: .password)
            case .newAccount:
                NewAccountView(fullName: $state.form.fullName,
                               newPassword: $state.form.newPassword)
                    .focused($_focused, equals: .fullName)
            case .locateUser:
                LocateAccountView(outlet: state.locateMeOutlet)
            case .suggestions:
                EmptyView()
            }
        }
        .onChange(of: state.form.focus) { value in
            _focused = value
        }
        .onChange(of: _focused) { value in
            state.form.focus(field: value)
        }
        .onAppear {
            state.onAppear(fragment: fragment)
        }
    }
}

public struct OnboardingView: View {
    @StateObject var state: OnboardingState = .empty

    public init() {}

    public var body: some View {
        NavigationStack(path: $state.path) {
            OnboardingFragmentView(state: state, fragment: .main)
        }
    }
}

private struct OnboardingViewSample: View {
    var body: some View {
        OnboardingView()
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingViewSample()
    }
}
