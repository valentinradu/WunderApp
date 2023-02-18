//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI

enum LocateAccountControlName {
    case locateMe
    case locateLater
}

struct LocateAccountView: View {
    let outlet: Outlet<LocateAccountControlName>

    var body: some View {
        OnboardingContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                OnboardingHeading(prefix: .l10n.locateAccountPrefix,
                                  title: .l10n.locateAccountTitle)
                Text(.l10n.locateAccountInfo)
                    .modifier(OnboardingInfoStyle())
                    .frame(greedy: .horizontal, alignment: .leading)
                Spacer()
                Button {
                    outlet.fire(from: .locateMe)
                } label: {
                    Text(.l10n.locateAccountLocateMe)
                }
                Button(role: .cancel) {
                    outlet.fire(from: .locateLater)
                } label: {
                    Text(.l10n.locateAccountLocateLater)
                }
            }
        }
    }
}

struct LocateAccountViewSample: View {
    var body: some View {
        LocateAccountView(outlet: .inactive())
    }
}

public struct LocateAccountViewPreviews: PreviewProvider {
    public static var previews: some View {
        LocateAccountViewSample()
    }
}
