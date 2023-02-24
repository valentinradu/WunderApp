//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

enum NewAccountControlName {
    case signUpButton
    case logInButton
}

struct NewAccountView: View {
    @FocusState private var _focus: FormFieldName?
    @Binding var fullName: FormFieldModel
    @Binding var newPassword: FormFieldModel
    let canSignUp: Bool
    let outlet: Outlet<NewAccountControlName>

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.newAccountPrefix,
                              title: .l10n.newAccountTitle)
                VStack(alignment: .center, spacing: .ds.s1) {
                    FormField(text: $fullName.value,
                              placeholder: .l10n.newAccountFullNamePlaceholder)
                        .focused($_focus, equals: .fullName)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.words)
                        .environment(\.controlStatus, fullName.status)
                        .submitLabel(.next)
                        .onSubmit(of: .text) {
                            _focus = .newPassword
                        }
                    FormField(secureText: $newPassword.value,
                              isRevealed: $newPassword.isRedacted,
                              placeholder: .l10n.newAccountPasswordPlaceholder)
                        .focused($_focus, equals: .newPassword)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .environment(\.controlStatus, newPassword.status)
                        .submitLabel(.join)
                        .onSubmit(of: .text) {
                            outlet.fire(from: .signUpButton)
                        }
                }
                Spacer()
                Button {
                    outlet.fire(from: .signUpButton)
                } label: {
                    Text(.l10n.newAccountSignUp)
                }
                .disabled(!canSignUp)
                Button(role: .cancel) {
                    outlet.fire(from: .logInButton)
                } label: {
                    Text(.l10n.newAccountLogIn)
                }
            }
        }
    }
}

private struct NewAccountViewSample: View {
    @State private var _fullName: FormFieldModel = .init()
    @State private var _password: FormFieldModel = .init()

    var body: some View {
        NewAccountView(fullName: $_fullName,
                       newPassword: $_password,
                       canSignUp: false,
                       outlet: .inactive())
    }
}

struct NewAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        NewAccountViewSample()
    }
}
