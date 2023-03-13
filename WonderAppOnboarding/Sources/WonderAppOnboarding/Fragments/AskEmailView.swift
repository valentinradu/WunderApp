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
    @Environment(\.navigationContext) private var _navigationContext
    @Binding var form: FormState

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askEmailPrefix,
                              title: .l10n.askEmailTitle)
                FormField(text: $form.emailField.value,
                          placeholder: .l10n.askEmailPlaceholder)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, form.emailField.status)
                    .focused($form.focus, equals: .email)
                    .onSubmit(of: .text, _onAttemptAdvance)
                Spacer()
                Button(action: _onAttemptAdvance,
                       label: {
                           Text(.l10n.askEmailContinue)
                       })
                       .disabled(!form.emailField.status.isSuccess)
            }
        }
        .submitLabel(.next)
        .animation(.easeInOut, value: form.emailField.status.isSuccess)
        .task {
            form.focus = .email
        }
    }

    private func _onAttemptAdvance() {
        if form.emailField.status.isSuccess {
            _navigationContext.present(fragment: FragmentName.newAccount)
        }
    }
}

private struct AskEmailViewSample: View {
    @State private var _form: FormState = .init()

    var body: some View {
        AskEmailView(form: $_form)
    }
}

struct AskEmailViewPreviews: PreviewProvider {
    static var previews: some View {
        AskEmailViewSample()
    }
}
