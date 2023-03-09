//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

struct NewAccountView: View {
    @Environment(\.present) private var _present
    @FocusState private var _focus: FormFieldName?
    @Binding var form: FormViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.newAccountPrefix,
                              title: .l10n.newAccountTitle)
                VStack(alignment: .center, spacing: .ds.s1) {
                    FormField(text: $form.fullName.value,
                              placeholder: .l10n.newAccountFullNamePlaceholder)
                        .focused($form.focus, equals: .fullName)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.words)
                        .environment(\.controlStatus, form.fullName.status)
                        .submitLabel(.next)
                        .focused($form.focus, equals: .fullName)
                        .onSubmit(of: .text) {
                            _focus = .newPassword
                        }
                    FormField(secureText: $form.newPassword.value,
                              isRevealed: $form.newPassword.isRedacted,
                              placeholder: .l10n.newAccountPasswordPlaceholder)
                        .focused($form.focus, equals: .newPassword)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .environment(\.controlStatus, form.newPassword.status)
                        .submitLabel(.join)
                        .focused($form.focus, equals: .newPassword)
                        .onSubmit(of: .text) {
                            _onSignUp()
                        }
                }
                Spacer()
                Button {
                    _onSignUp()
                } label: {
                    Text(.l10n.newAccountSignUp)
                }
                .disabled(!form.areSignUpCredentialsValid)
                Button(role: .cancel) {
                    _present(FragmentName.newAccount)
                } label: {
                    Text(.l10n.newAccountLogIn)
                }
            }
            .animation(.easeInOut, value: form.areSignUpCredentialsValid)
        }
    }

    private func _onSignUp() {
        //
    }
}

private struct NewAccountViewSample: View {
    @State private var _form: FormViewModel = .init()

    var body: some View {
        NewAccountView(form: $_form)
    }
}

struct NewAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        NewAccountViewSample()
    }
}
