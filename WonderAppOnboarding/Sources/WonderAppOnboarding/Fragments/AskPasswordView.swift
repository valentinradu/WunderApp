//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppDomain
import WonderAppExtensions

struct AskPasswordView: View {
    @Environment(\.navigationContext) private var _navigationContext
    @Service(\.auth) private var _authService
    @FocusState private var _focused: Bool
    @Binding var form: FormState

    var body: some View {
        FormContainer {
            AsyncContextReader { asyncContext in
                VStack(alignment: .center, spacing: .ds.s4) {
                    DoubleHeading(prefix: .l10n.askPasswordPrefix,
                                  title: .l10n.askPasswordTitle)
                    FormField(secureText: $form.passwordField.value,
                              isRevealed: $form.passwordField.isRedacted,
                              placeholder: .l10n.askPasswordPlaceholder)
                        .focused($_focused)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .environment(\.controlStatus, form.passwordField.status)
                    Spacer()
                    Button(
                        action: {
                            asyncContext.performTask(named: TaskName.logIn) {
                                try await _onLogIn()
                            }
                        },
                        label: {
                            Text(.l10n.askPasswordLogIn)
                        }
                    )
                    .disabled(!form.areLogInCredentialsValid)
                    Button(role: .cancel) {
                        _navigationContext.present(fragment: FragmentName.newAccount)
                    } label: {
                        Text(.l10n.askPasswordSignUp)
                    }
                }
                .animation(.easeInOut, value: form.areLogInCredentialsValid)
            }
        }
    }

    private func _onLogIn() async throws {
        form.toNewAccountControl.status = .loading
        try await _authService.logIn(email: form.emailField.value,
                                     password: form.passwordField.value)
        _navigationContext.present(fragment: FragmentName.locateUser)
    }
}

private struct AskPasswordViewSample: View {
    @State private var _form: FormState = .init()

    var body: some View {
        AskPasswordView(form: $_form)
    }
}

struct AskPasswordViewPreviews: PreviewProvider {
    static var previews: some View {
        AskPasswordViewSample()
    }
}
