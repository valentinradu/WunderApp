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
    @Environment(\.present) private var _present
    @FocusState private var _focus: FormFieldName?
    @Binding var form: FormViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askEmailPrefix,
                              title: .l10n.askEmailTitle)
                FormField(text: $form.email.value,
                          placeholder: .l10n.askEmailPlaceholder)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .environment(\.controlStatus, form.email.status)
                    .focused($form.focus, equals: .email)
                    .onSubmit(of: .text) {
                        _focus = .email
                    }
                Spacer()
                Button {
                    _present(FragmentName.newAccount)
                } label: {
                    Text(.l10n.askEmailContinue)
                }
                .disabled(!form.email.status.isSuccess)
            }
        }
        .submitLabel(.next)
        .animation(.easeInOut, value: form.email.status.isSuccess)
    }
}

private struct AskEmailViewSample: View {
    @State private var _form: FormViewModel = .init()

    var body: some View {
        AskEmailView(form: $_form)
    }
}

struct AskEmailViewPreviews: PreviewProvider {
    static var previews: some View {
        AskEmailViewSample()
    }
}
