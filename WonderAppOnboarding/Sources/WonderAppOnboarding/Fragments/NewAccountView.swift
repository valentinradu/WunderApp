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
    private enum FormFieldName {
        case fullName
        case newPassword
    }

    @Environment(\.navigationContext) private var _navigationContext
    @FocusState private var _focused: FormFieldName?
    @State private var _isPasswordRedacted: Bool = false
    @Binding var form: FormState

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.newAccountPrefix,
                              title: .l10n.newAccountTitle)
                VStack(alignment: .center, spacing: .ds.s1) {
                    FormField(text: $form.newPasswordField.value,
                              placeholder: .l10n.newAccountFullNamePlaceholder)
                        .focused($_focused, equals: .fullName)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.words)
                        .environment(\.controlStatus, form.fullNameField.status)
                        .submitLabel(.next)
                        .onSubmit(of: .text) {
                            _focused = .newPassword
                        }
                    FormField(secureText: $form.newPasswordField.value,
                              isRevealed: $_isPasswordRedacted,
                              placeholder: .l10n.newAccountPasswordPlaceholder)
                        .focused($_focused, equals: .newPassword)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .environment(\.controlStatus, form.newPasswordField.status)
                        .submitLabel(.join)
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
                    _navigationContext.present(fragment: FragmentName.newAccount)
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
    @State private var _form: FormState = .init()

    var body: some View {
        NewAccountView(form: $_form)
    }
}

struct NewAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        NewAccountViewSample()
    }
}
