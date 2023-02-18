//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

struct AskEmailView: View {
    @FocusState private var _focus: OnboardingFormFieldName?
    @Binding var email: OnboardingFormFieldState
    let canMoveToNextStep: Bool
    let outlet: Outlet<Void>

    var body: some View {
        OnboardingContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                OnboardingHeading(prefix: .l10n.askEmailPrefix,
                                  title: .l10n.askEmailTitle)
                OnboardingFormField(text: $email.value,
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

struct AskEmailViewSample: View {
    @State private var _email: OnboardingFormFieldState = .empty

    var body: some View {
        AskEmailView(email: $_email,
                     canMoveToNextStep: false,
                     outlet: .inactive())
    }
}

public struct AskEmailViewPreviews: PreviewProvider {
    public static var previews: some View {
        AskEmailViewSample()
    }
}
