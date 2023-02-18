//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI

extension Onboarding {
    enum AskPasswordControlName {
        case logInButton
        case signUpButton
    }

    struct AskPasswordView: View {
        @FocusState private var _focus: FormFieldName?
        @Binding var password: FormSecureField
        let canMoveToNextStep: Bool
        let outlet: Outlet<AskPasswordControlName>

        var body: some View {
            FragmentContainer {
                VStack(alignment: .center, spacing: .ds.s4) {
                    Heading(prefix: .l10n.askPasswordPrefix,
                            title: .l10n.askPasswordTitle)
                    FormFieldView(secureText: $password.value,
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

    private struct AskPasswordViewSample: View {
        @State private var _password: FormSecureField = .empty

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
