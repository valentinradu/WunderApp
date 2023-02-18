//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI

struct NewAccountView: View {
    @FocusState private var _focus: OnboardingFormFieldName?
    @Binding var fullName: OnboardingFormFieldState
    @Binding var newPassword: OnboardingFormSecureFieldState

    var body: some View {
        OnboardingContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                OnboardingHeading(prefix: .l10n.newAccountPrefix,
                                  title: .l10n.newAccountTitle)
                VStack(alignment: .center, spacing: .ds.s1) {
                    OnboardingFormField(text: $fullName.value,
                                        status: fullName.status,
                                        placeholder: .l10n.newAccountFullNamePlaceholder)
                        .focused($_focus, equals: .fullName)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.words)
                    OnboardingFormField(secureText: $newPassword.value,
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

struct NewAccountViewSample: View {
    @State private var _fullName: OnboardingFormFieldState = .empty
    @State private var _password: OnboardingFormSecureFieldState = .empty

    var body: some View {
        NewAccountView(fullName: $_fullName, newPassword: $_password)
    }
}

public struct NewAccountViewPreviews: PreviewProvider {
    public static var previews: some View {
        NewAccountViewSample()
    }
}
