//
//  WelcomeView.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

private struct WelcomeTabItem: View {
    let text: AttributedString
    var body: some View {
        Text(text)
            .modifier(InfoParagraphStyle())
            .padding(.horizontal, .ds.s4)
            .frame(greedy: .all, alignment: .topLeading)
    }
}

struct WelcomeView: View {
    @Binding var page: Int
    let outlet: Outlet<Void>

    var body: some View {
        FragmentContainer {
            VStack(spacing: .ds.s6) {
                HeaderAnimation()
                    .edgesIgnoringSafeArea(.horizontal)
                    .overlay(alignment: .topLeading) {
                        Image.ds.logo
                    }
                VStack(alignment: .center, spacing: .ds.s4) {
                    DoubleHeading(prefix: .l10n.welcomeLandingGreeting,
                                  title: .l10n.welcomeLandingCallout)
                    PaginationCarousel(page: $page) {
                        WelcomeTabItem(text: .l10n.welcomeLandingInfoFirst)
                        WelcomeTabItem(text: .l10n.welcomeLandingInfoSecond)
                        WelcomeTabItem(text: .l10n.welcomeLandingInfoThird)
                    }
                    .ignoresSafeArea(.all, edges: .horizontal)
                    .safeAreaInset(edge: .bottom) {
                        PaginationIndicator(page: page, of: 3)
                    }
                    .animation(.easeInOut, value: page)
                    Button {
                        outlet.fire()
                    }
                    label: {
                        Text(.l10n.welcomeContinue)
                    }
                }
            }
        }
    }
}

private struct WelcomeViewSample: View {
    @State private var _page: Int = 0

    var body: some View {
        WelcomeView(page: $_page,
                    outlet: Outlet {
                        _page += _page < 2 ? 1 : 0
                    })
    }
}

struct WelcomeViewPreviews: PreviewProvider {
    static var previews: some View {
        WelcomeViewSample()
    }
}
