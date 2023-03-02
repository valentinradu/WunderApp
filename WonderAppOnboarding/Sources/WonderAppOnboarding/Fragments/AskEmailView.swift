//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

struct AskEmailView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askEmailPrefix,
                              title: .l10n.askEmailTitle)
                FormField(text: $viewModel.form.email.value,
                          placeholder: .l10n.askEmailPlaceholder)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, viewModel.form.email.status)
                    .focused($viewModel.form.focus, equals: .email)
                    .onSubmit(of: .text) {
                        viewModel.onSubmit(formFieldName: .email)
                    }
                Spacer()
                Button {
                    viewModel.onInteraction(button: .towardsSignUpButton)
                } label: {
                    Text(.l10n.askEmailContinue)
                }
                .disabled(!viewModel.form.email.status.isSuccess)
            }
        }
        .submitLabel(.next)
        .animation(.easeInOut, value: viewModel.form.email.status.isSuccess)
    }
}

private struct AskEmailViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        AskEmailView(viewModel: _model)
    }
}

struct AskEmailViewPreviews: PreviewProvider {
    static var previews: some View {
        AskEmailViewSample()
    }
}
