//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI

struct AskPasswordView: View {
    enum Action {
        case logIn
        case signUp
    }

    @Environment(\.dispatch) private var _dispatch
    @FocusState private var _firstResponderFocus
    @State private var _isPasswordRevealed: Bool = false
    @Binding var password: String
    @Binding var passwordStatus: OnboardingFormFieldStatus

    var body: some View {
        OnboardingContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                VStack(alignment: .leading, spacing: .ds.s4) {
                    VStack(alignment: .leading) {
                        Text(.l10n.askPasswordFollowUp)
                            .font(.ds.lg)
                            .bold(true)
                            .foregroundColor(.ds.oceanBlue300)
                        Text(.l10n.askPasswordTitle)
                            .font(.ds.xxl)
                            .bold(true)
                    }
                    .frame(greedy: .horizontal, alignment: .leading)
                }
                OnboardingFormField(secureText: $password,
                                    isRevealed: $_isPasswordRevealed,
                                    status: passwordStatus)
                    .focused($_firstResponderFocus)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Spacer()
                Button {
                    _dispatch(Action.logIn)
                } label: {
                    Text(.l10n.askPasswordLogIn)
                }
                Button(role: .cancel) {
                    _dispatch(Action.signUp)
                } label: {
                    Text(.l10n.askPasswordSignUp)
                }
            }
        }
        .onSubmit {
            _dispatch(Action.logIn)
        }
        .onAppear {
            _firstResponderFocus = true
        }
    }
}

struct AskPasswordViewSample: View {
    @State private var _password: String = ""
    @State private var _passwordStatus: OnboardingFormFieldStatus = .idle

    var body: some View {
        AskPasswordView(password: $_password,
                        passwordStatus: $_passwordStatus)
    }
}

public struct AskPasswordViewPreviews: PreviewProvider {
    public static var previews: some View {
        AskPasswordViewSample()
    }
}
