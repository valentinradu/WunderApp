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
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.newAccountPrefix,
                              title: .l10n.newAccountTitle)
                VStack(alignment: .center, spacing: .ds.s1) {
                    FormField(text: $viewModel.form.fullName.value,
                              placeholder: .l10n.newAccountFullNamePlaceholder)
                        .focused($viewModel.form.focus, equals: .fullName)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.words)
                        .environment(\.controlStatus, viewModel.form.fullName.status)
                        .submitLabel(.next)
                        .focused($viewModel.form.focus, equals: .fullName)
                        .onSubmit(of: .text) {
                            viewModel.onSubmit(formFieldName: .fullName)
                        }
                    FormField(secureText: $viewModel.form.newPassword.value,
                              isRevealed: $viewModel.form.newPassword.isRedacted,
                              placeholder: .l10n.newAccountPasswordPlaceholder)
                        .focused($viewModel.form.focus, equals: .newPassword)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .environment(\.controlStatus, viewModel.form.newPassword.status)
                        .submitLabel(.join)
                        .focused($viewModel.form.focus, equals: .newPassword)
                        .onSubmit(of: .text) {
                            viewModel.onSubmit(formFieldName: .newPassword)
                        }
                }
                Spacer()
                Button {
                    viewModel.onInteraction(button: .signUpButton)
                } label: {
                    Text(.l10n.newAccountSignUp)
                }
                .disabled(!viewModel.form.areSignUpCredentialsValid)
                Button(role: .cancel) {
                    viewModel.onInteraction(button: .towardsLogInButton)
                } label: {
                    Text(.l10n.newAccountLogIn)
                }
            }
            .animation(.easeInOut, value: viewModel.form.areSignUpCredentialsValid)
        }
    }
}

private struct NewAccountViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        NewAccountView(viewModel: _model)
    }
}

struct NewAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        NewAccountViewSample()
    }
}
