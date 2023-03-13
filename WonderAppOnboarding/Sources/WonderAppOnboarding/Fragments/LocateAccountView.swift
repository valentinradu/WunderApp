//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppDomain
import WonderAppExtensions

struct LocateAccountView: View {
    @Environment(\.navigationContext) private var _navigationContext
    @Service(\.account) private var _accountService

    var body: some View {
        FormContainer {
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.locateAccountPrefix,
                              title: .l10n.locateAccountTitle)
                Text(.l10n.locateAccountInfo)
                    .modifier(InfoParagraphStyle())
                    .frame(greedy: .horizontal, alignment: .leading)
                Spacer()
                Button(action: _onLocateMe,
                       label: {
                           Text(.l10n.locateAccountLocateMe)
                       })
                Button(role: .cancel) {
                    _navigationContext.present(fragment: FragmentName.suggestions)
                } label: {
                    Text(.l10n.locateAccountLocateLater)
                }
            }
        }
    }

    private func _onLocateMe() {
        //
    }
}

private struct LocateAccountViewSample: View {
    var body: some View {
        LocateAccountView()
    }
}

struct LocateAccountViewPreviews: PreviewProvider {
    static var previews: some View {
        LocateAccountViewSample()
    }
}
