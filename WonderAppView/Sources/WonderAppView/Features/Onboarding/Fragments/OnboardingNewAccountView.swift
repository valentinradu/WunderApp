//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI

extension Onboarding {
    struct NewAccountView: View {
        @FocusState private var _focus: FormFieldName?
        @Binding var fullName: FormField
        @Binding var newPassword: FormSecureField

        var body: some View {
            FragmentContainer {
                VStack(alignment: .center, spacing: .ds.s4) {
                    Heading(prefix: .l10n.newAccountPrefix,
                            title: .l10n.newAccountTitle)
                    VStack(alignment: .center, spacing: .ds.s1) {
                        FormFieldView(text: $fullName.value,
                                      status: fullName.status,
                                      placeholder: .l10n.newAccountFullNamePlaceholder)
                            .focused($_focus, equals: .fullName)
                            .autocorrectionDisabled()
                            .keyboardType(.alphabet)
                            .textInputAutocapitalization(.words)
                        FormFieldView(secureText: $newPassword.value,
                                      isRevealed: $newPassword.isRevealed,
                                      status: newPassword.status,
                                      placeholder: .l10n.newAccountPasswordPlaceholder)
                            .focused($_focus, equals: .newPassword)
                            .autocorrectionDisabled()
                            .keyboardType(.alphabet)
                            .textInputAutocapitalization(.never)
                    }
                    Spacer()
                    Button {
                        //
                    } label: {
                        Text(.l10n.newAccountSignUp)
                    }
                    Button(role: .cancel) {
                        //
                    } label: {
                        Text(.l10n.newAccountLogIn)
                    }
                }
            }
        }
    }

    private struct NewAccountViewSample: View {
        @State private var _fullName: FormField = .empty
        @State private var _password: FormSecureField = .empty

        var body: some View {
            NewAccountView(fullName: $_fullName, newPassword: $_password)
        }
    }

    struct NewAccountViewPreviews: PreviewProvider {
        static var previews: some View {
            NewAccountViewSample()
        }
    }
}
