//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

struct LocateAccountView: View {
    @ObservedObject var model: OnboardingViewModel

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.locateAccountPrefix,
                              title: .l10n.locateAccountTitle)
                Text(.l10n.locateAccountInfo)
                    .modifier(InfoParagraphStyle())
                    .frame(greedy: .horizontal, alignment: .leading)
                Spacer()
                Button {
                    model.onInteraction(button: .locateMeButton)
                } label: {
                    Text(.l10n.locateAccountLocateMe)
                }
                Button(role: .cancel) {
                    model.onInteraction(button: .skipLocateMeButton)
                } label: {
                    Text(.l10n.locateAccountLocateLater)
                }
            }
        }
    }
}

private struct LocateAccountViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        LocateAccountView(model: _model)
    }
}

struct LocateAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        LocateAccountViewSample()
    }
}
