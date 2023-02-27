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
    @ObservedObject var model: OnboardingModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.newAccountPrefix,
                              title: .l10n.newAccountTitle)
                VStack(alignment: .center, spacing: .ds.s1) {
                    FormField(text: $model.form.fullName.value,
                              placeholder: .l10n.newAccountFullNamePlaceholder)
                        .focused($model.form.focus, equals: .fullName)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.words)
                        .environment(\.controlStatus, model.form.fullName.status)
                        .submitLabel(.next)
                        .focused($model.form.focus, equals: .fullName)
                        .onSubmit(of: .text) {
                            model.onSubmit(formFieldName: .fullName)
                        }
                    FormField(secureText: $model.form.newPassword.value,
                              isRevealed: $model.form.newPassword.isRedacted,
                              placeholder: .l10n.newAccountPasswordPlaceholder)
                        .focused($model.form.focus, equals: .newPassword)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .environment(\.controlStatus, model.form.newPassword.status)
                        .submitLabel(.join)
                        .focused($model.form.focus, equals: .newPassword)
                        .onSubmit(of: .text) {
                            model.onSubmit(formFieldName: .newPassword)
                        }
                }
                Spacer()
                Button {
                    model.onInteraction(button: .signUpButton)
                } label: {
                    Text(.l10n.newAccountSignUp)
                }
                .disabled(!model.form.areSignUpCredentialsValid)
                Button(role: .cancel) {
                    model.onInteraction(button: .towardsLogInButton)
                } label: {
                    Text(.l10n.newAccountLogIn)
                }
            }
            .animation(.easeInOut, value: model.form.areSignUpCredentialsValid)
        }
    }
}

private struct NewAccountViewSample: View {
    @StateObject private var _model: OnboardingModel = .init()

    var body: some View {
        NewAccountView(model: _model)
    }
}

struct NewAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        NewAccountViewSample()
    }
}
