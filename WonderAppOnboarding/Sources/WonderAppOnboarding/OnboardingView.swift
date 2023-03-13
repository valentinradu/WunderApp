//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import os
import SwiftUI
import WonderAppDesignSystem
import WonderAppDomain
import WonderAppExtensions

private struct OnboardingFragmentView: View {
    let fragment: FragmentName
    @Binding var form: FormState

    var body: some View {
        ZStack {
            Group {
                switch fragment {
                case .main, .welcome:
                    WelcomeView()
                case .askEmail:
                    AskEmailView(form: $form)
                case .askPassword:
                    AskPasswordView(form: $form)
                case .newAccount:
                    NewAccountView(form: $form)
                case .locateUser:
                    LocateAccountView()
                case .suggestions:
                    SuggestionsView()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

public struct OnboardingView: View {
    @Environment(\.navigationContext) private var _navigationContext
    @State private var _form: FormState = .init()

    public init() {}

    public var body: some View {
        OnboardingFragmentView(fragment: .main, form: $_form)
            .navigationDestination(for: FragmentName.self) { fragment in
                OnboardingFragmentView(fragment: fragment, form: $_form)
            }
            .humanReadableError { error in
                if let error = error as? InputValidatorError {
                    return error.localizedDescription
                } else {
                    return nil
                }
            }
    }
}

private struct OnboardingViewSample: View {
    @State private var _path: NavigationPath = .init()

    var body: some View {
        let navigationContext = NavigationContext(path: $_path)
        OnboardingView()
            .environment(\.navigationContext, navigationContext)
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingViewSample()
    }
}
