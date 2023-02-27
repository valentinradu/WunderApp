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
    @ObservedObject var model: OnboardingModel

    var body: some View {
        let canMoveToNextStep = model.canPresent(fragment: .newAccount)
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
                .disabled(!canMoveToNextStep)
            }
        }
        .submitLabel(.next)
        .animation(.easeInOut, value: canMoveToNextStep)
    }
}

private struct AskEmailViewSample: View {
    @StateObject private var _model: OnboardingModel = .init()

    var body: some View {
        AskEmailView(model: _model)
    }
}

struct AskEmailViewPreviews: PreviewProvider {
    static var previews: some View {
        AskEmailViewSample()
    }
}
