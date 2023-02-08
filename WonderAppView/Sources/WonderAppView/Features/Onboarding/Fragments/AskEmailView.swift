//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

struct AskEmailView: View {
    enum Action {
        case advance
    }

    @Environment(\.dispatch) private var _dispatch
    @FocusState private var _firstResponderFocus
    @Binding var email: String
    @Binding var emailStatus: OnboardingFormFieldStatus

    var body: some View {
        OnboardingContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                VStack(alignment: .leading, spacing: .ds.s4) {
                    VStack(alignment: .leading) {
                        Text(.l10n.askEmailFollowUp)
                            .font(.ds.lg)
                            .bold(true)
                            .foregroundColor(.ds.oceanBlue300)
                        Text(.l10n.askEmailQuestion)
                            .font(.ds.xxl)
                            .bold(true)
                    }
                    .frame(greedy: .horizontal, alignment: .leading)
                }
                OnboardingFormField(text: $email,
                                    status: emailStatus)
                    .focused($_firstResponderFocus)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Spacer()
                Button {
                    _dispatch(Action.advance)
                } label: {
                    Text(.l10n.welcomeContinue)
                }
            }
        }
        .onSubmit {
            _dispatch(Action.advance)
        }
        .onAppear {
            _firstResponderFocus = true
        }
    }
}

struct AskEmailViewSample: View {
    @State private var _email: String = ""
    @State private var _emailStatus: OnboardingFormFieldStatus = .idle

    var body: some View {
        AskEmailView(email: $_email,
                     emailStatus: $_emailStatus)
    }
}

public struct AskEmailViewPreviews: PreviewProvider {
    public static var previews: some View {
        AskEmailViewSample()
    }
}
