//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

extension Onboarding {
    enum AskPasswordControlName {
        case logInButton
        case signUpButton
    }

    struct AskPasswordView: View {
        @FocusState private var _focus: FormFieldName?
        @Binding var password: FormSecureFieldState
        let canMoveToNextStep: Bool
        let outlet: Outlet<AskPasswordControlName>

        var body: some View {
            FragmentContainer {
                VStack(alignment: .center, spacing: .ds.s4) {
                    DoubleHeading(prefix: .l10n.askPasswordPrefix,
                                  title: .l10n.askPasswordTitle)
                    FormField(secureText: $password.value,
                              isRevealed: $password.isRevealed,
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

    private struct AskPasswordViewSample: View {
        @State private var _password: FormSecureFieldState = .empty

        var body: some View {
            AskPasswordView(password: $_password,
                            canMoveToNextStep: false,
                            outlet: .inactive())
        }
    }

    struct AskPasswordViewPreviews: PreviewProvider {
        static var previews: some View {
            AskPasswordViewSample()
        }
    }
}
