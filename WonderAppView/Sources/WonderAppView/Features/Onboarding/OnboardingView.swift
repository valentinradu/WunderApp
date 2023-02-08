//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

enum OnboardingFragment: Codable, Hashable {
    case welcome
    case askEmail
    case askPassword
    case createAccount
    case locateUser
    case suggestions
}

struct OnboardingView: View {
    @SceneStorage("onboarding.path") private var _path: NavigationPath = .init()
    @SceneStorage("onboarding.email") private var _email: String = ""
    @SceneStorage("onboarding.emailStatus") private var _emailStatus: OnboardingFormFieldStatus = .idle
    @SecureStorage("onboarding.password") private var _password: String = ""
    @SceneStorage("onboarding.passwordStatus") private var _paswordStatus: OnboardingFormFieldStatus = .idle

    var body: some View {
        NavigationStack(path: $_path) {
            WelcomeView()
                .navigationDestination(for: OnboardingFragment.self) { fragment in
                    Group {
                        switch fragment {
                        case .welcome:
                            WelcomeView()
                        case .askEmail:
                            AskEmailView(email: $_email,
                                         emailStatus: $_emailStatus)
                        case .askPassword:
                            AskPasswordView(password: $_password,
                                            passwordStatus: $_paswordStatus)
                        case .createAccount:
                            EmptyView()
                        case .locateUser:
                            EmptyView()
                        case .suggestions:
                            EmptyView()
                        }
                    }
                    .toolbar {
                        EmptyView()
                    }
                }
        }
        .handle(actions: WelcomeView.Action.self) { action in
            switch action {
            case .advance:
                _path.append(OnboardingFragment.askEmail)
            }
        }
        .handle(actions: AskEmailView.Action.self) { action in
            switch action {
            case .advance:
                _path.append(OnboardingFragment.askPassword)
            }
        }
        .handle(actions: AskPasswordView.Action.self) { action in
            switch action {
            case .signUp:
                break
            case .logIn:
                break
            }
        }
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
