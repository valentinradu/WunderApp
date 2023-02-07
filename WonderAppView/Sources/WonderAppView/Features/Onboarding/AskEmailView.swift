//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

struct AskEmailView: View {
    @SceneStorage(storageKey: .onboardingEmail) private var _onboardingEmail = ""
    @SceneStorage(storageKey: .onboardingEmailStatus) private var _onboardingEmailStatus: OnboardingFormFieldStatus =
        .idle

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
                OnboardingFormField(text: $_onboardingEmail, status: _onboardingEmailStatus)
                Spacer()
                Button {
                    _onContinueTap()
                } label: {
                    Text(.l10n.welcomeContinue)
                }
            }
        }
    }

    func _onContinueTap() {}
}

public struct AskEmailViewPreviews: PreviewProvider {
    public static var previews: some View {
        AskEmailView()
    }
}
