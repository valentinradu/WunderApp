//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI

extension Onboarding {
    enum LocateAccountControlName {
        case locateMe
        case locateLater
    }

    struct LocateAccountView: View {
        let outlet: Outlet<LocateAccountControlName>

        var body: some View {
            FragmentContainer {
                VStack(alignment: .center, spacing: .ds.s4) {
                    Heading(prefix: .l10n.locateAccountPrefix,
                            title: .l10n.locateAccountTitle)
                    Text(.l10n.locateAccountInfo)
                        .modifier(InfoStyle())
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

    private struct LocateAccountViewSample: View {
        var body: some View {
            LocateAccountView(outlet: .inactive())
        }
    }

    struct LocateAccountViewPreviews: PreviewProvider {
        static var previews: some View {
            LocateAccountViewSample()
        }
    }
}