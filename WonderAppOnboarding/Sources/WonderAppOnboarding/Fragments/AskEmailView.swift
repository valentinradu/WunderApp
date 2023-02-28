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
    @ObservedObject var model: OnboardingViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askEmailPrefix,
                              title: .l10n.askEmailTitle)
                FormField(text: $model.form.email.value,
                          placeholder: .l10n.askEmailPlaceholder)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, model.form.email.status)
                    .focused($model.form.focus, equals: .email)
                    .onSubmit(of: .text) {
                        model.onSubmit(formFieldName: .email)
                    }
                Spacer()
                Button {
                    model.onInteraction(button: .towardsSignUpButton)
                } label: {
                    Text(.l10n.askEmailContinue)
                }
                .disabled(!model.form.email.status.isSuccess)
            }
        }
        .submitLabel(.next)
        .animation(.easeInOut, value: model.form.email.status.isSuccess)
    }
}

private struct AskEmailViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        AskEmailView(model: _model)
    }
}

struct AskEmailViewPreviews: PreviewProvider {
    static var previews: some View {
        AskEmailViewSample()
    }
}
