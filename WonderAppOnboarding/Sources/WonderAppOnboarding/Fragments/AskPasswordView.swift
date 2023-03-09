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
    @Environment(\.present) private var _present
    @Environment(\.dispatch) private var _dispatch
    @Environment(\.service.auth) private var _authService
    @FocusState private var _focus: FormFieldName?
    @State private var _logInControlStatus: ControlStatus = .idle
    @Binding var form: FormViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askPasswordPrefix,
                              title: .l10n.askPasswordTitle)
                FormField(secureText: $form.password.value,
                          isRevealed: $form.password.isRedacted,
                          placeholder: .l10n.askPasswordPlaceholder)
                    .focused($form.focus, equals: .password)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, form.password.status)
                Spacer()
                Button(action: _onLogIn,
                       label: {
                           Text(.l10n.askPasswordLogIn)
                       })
                       .disabled(!form.areLogInCredentialsValid)
                Button(role: .cancel) {
                    _present(FragmentName.newAccount)
                } label: {
                    Text(.l10n.askPasswordSignUp)
                }
            }
            .animation(.easeInOut, value: form.areLogInCredentialsValid)
        }
    }

    private func _onLogIn() {
        _logInControlStatus = .loading
        _dispatch(ButtonName.logInButton) {
            try await _authService.logIn(email: form.email.value,
                                         password: form.email.value)
            _present(FragmentName.locateUser)
        }
    }
}

private struct AskPasswordViewSample: View {
    @State private var _form: FormViewModel = .init()

    var body: some View {
        AskPasswordView(form: $_form)
    }
}

struct AskPasswordViewPreviews: PreviewProvider {
    static var previews: some View {
        AskPasswordViewSample()
    }
}
