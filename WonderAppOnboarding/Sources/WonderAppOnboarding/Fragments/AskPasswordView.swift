//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

struct AskPasswordView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askPasswordPrefix,
                              title: .l10n.askPasswordTitle)
                FormField(secureText: $viewModel.form.password.value,
                          isRevealed: $viewModel.form.password.isRedacted,
                          placeholder: .l10n.askPasswordPlaceholder)
                    .focused($viewModel.form.focus, equals: .password)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, viewModel.form.password.status)
                Spacer()
                Button {
                    viewModel.onInteraction(button: .logInButton)
                } label: {
                    Text(.l10n.askPasswordLogIn)
                }
                .disabled(!viewModel.form.areLogInCredentialsValid)
                Button(role: .cancel) {
                    viewModel.onInteraction(button: .towardsSignUpButton)
                } label: {
                    Text(.l10n.askPasswordSignUp)
                }
            }
            .animation(.easeInOut, value: viewModel.form.areLogInCredentialsValid)
        }
    }
}

private struct AskPasswordViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        AskPasswordView(viewModel: _model)
    }
}

struct AskPasswordViewPreviews: PreviewProvider {
    static var previews: some View {
        AskPasswordViewSample()
    }
}
