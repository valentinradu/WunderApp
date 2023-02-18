//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

extension Onboarding {
    struct AskEmailView: View {
        @FocusState private var _focus: FormFieldName?
        @Binding var email: FormField
        let canMoveToNextStep: Bool
        let outlet: Outlet<Void>

        var body: some View {
            FragmentContainer {
                VStack(alignment: .center, spacing: .ds.s4) {
                    Heading(prefix: .l10n.askEmailPrefix,
                            title: .l10n.askEmailTitle)
                    FormFieldView(text: $email.value,
                                  status: email.status,
                                  placeholder: .l10n.askEmailPlaceholder)
                        .focused($_focus, equals: .email)
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
                }
            }
        }
    }

    private struct AskEmailViewSample: View {
        @State private var _email: FormField = .empty

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
}
