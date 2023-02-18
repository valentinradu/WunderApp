//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI

enum AskPasswordControlName {
    case logInButton
    case signUpButton
}

struct AskPasswordView: View {
    @FocusState private var _focus: OnboardingFormFieldName?
    @Binding var password: OnboardingFormSecureFieldState
    let canMoveToNextStep: Bool
    let outlet: Outlet<AskPasswordControlName>

    var body: some View {
        OnboardingContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                OnboardingHeading(prefix: .l10n.askPasswordPrefix,
                                  title: .l10n.askPasswordTitle)
                OnboardingFormField(secureText: $password.value,
                                    isRevealed: $password.isRevealed,
                                    status: password.status,
                                    placeholder: .l10n.askPasswordPlaceholder)
                    .focused($_focus, equals: .password)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Spacer()
                Button {
                    //
                } label: {
                    Text(.l10n.askPasswordLogIn)
                }
                .disabled(!canMoveToNextStep)
                Button(role: .cancel) {
                    //
                } label: {
                    Text(.l10n.askPasswordSignUp)
                }
            }
        }
    }
}

struct AskPasswordViewSample: View {
    @State private var _password: OnboardingFormSecureFieldState = .empty

    var body: some View {
        AskPasswordView(password: $_password,
                        canMoveToNextStep: false,
                        outlet: .inactive())
    }
}

public struct AskPasswordViewPreviews: PreviewProvider {
    public static var previews: some View {
        AskPasswordViewSample()
    }
}
