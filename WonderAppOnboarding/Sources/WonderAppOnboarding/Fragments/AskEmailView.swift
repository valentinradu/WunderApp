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
    @Binding var email: FormFieldState
    let canMoveToNextStep: Bool
    let outlet: Outlet<Void>

    var body: some View {
        FragmentContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.askEmailPrefix,
                              title: .l10n.askEmailTitle)
                FormField(text: $email.value,
                          placeholder: .l10n.askEmailPlaceholder)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Spacer()
                Button {
                    outlet.fire()
                } label: {
                    Text(.l10n.askEmailContinue)
                }
                .disabled(!canMoveToNextStep)
                .animation(.easeInOut, value: canMoveToNextStep)
            }
        }
    }
}

private struct AskEmailViewSample: View {
    @State private var _email: FormFieldState = .empty

    var body: some View {
        AskEmailView(email: $_email,
                     canMoveToNextStep: false,
                     outlet: .inactive())
    }
}

struct AskEmailViewPreviews: PreviewProvider {
    static var previews: some View {
        AskEmailViewSample()
    }
}
