//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

enum AskPasswordControlName {
    case logInButton
    case signUpButton
}

struct AskPasswordView: View {
    @FocusState private var _focus: FormFieldName?
    @Binding var password: FormFieldModel
    let canLogin: Bool
    let outlet: Outlet<AskPasswordControlName>

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askPasswordPrefix,
                              title: .l10n.askPasswordTitle)
                FormField(secureText: $password.value,
                          isRevealed: $password.isRedacted,
                          placeholder: .l10n.askPasswordPlaceholder)
                    .focused($_focus, equals: .password)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, password.status)
                Spacer()
                Button {
                    outlet.fire(from: .logInButton)
                } label: {
                    Text(.l10n.askPasswordLogIn)
                }
                .disabled(!canLogin)
                Button(role: .cancel) {
                    outlet.fire(from: .signUpButton)
                } label: {
                    Text(.l10n.askPasswordSignUp)
                }
            }
        }
    }
}

private struct AskPasswordViewSample: View {
    @State private var _password: FormFieldModel = .init()

    var body: some View {
        AskPasswordView(password: $_password,
                        canLogin: false,
                        outlet: .inactive())
    }
}

struct AskPasswordViewPreviews: PreviewProvider {
    static var previews: some View {
        AskPasswordViewSample()
    }
}
