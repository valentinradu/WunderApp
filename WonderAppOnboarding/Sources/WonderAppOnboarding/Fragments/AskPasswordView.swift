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
    @ObservedObject var model: OnboardingViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askPasswordPrefix,
                              title: .l10n.askPasswordTitle)
                FormField(secureText: $model.form.password.value,
                          isRevealed: $model.form.password.isRedacted,
                          placeholder: .l10n.askPasswordPlaceholder)
                    .focused($model.form.focus, equals: .password)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, model.form.password.status)
                Spacer()
                Button {
                    model.onInteraction(button: .logInButton)
                } label: {
                    Text(.l10n.askPasswordLogIn)
                }
                .disabled(!model.form.areLogInCredentialsValid)
                Button(role: .cancel) {
                    model.onInteraction(button: .towardsSignUpButton)
                } label: {
                    Text(.l10n.askPasswordSignUp)
                }
            }
            .animation(.easeInOut, value: model.form.areLogInCredentialsValid)
        }
    }
}

private struct AskPasswordViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        AskPasswordView(model: _model)
    }
}

struct AskPasswordViewPreviews: PreviewProvider {
    static var previews: some View {
        AskPasswordViewSample()
    }
}
