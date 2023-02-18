//
//  WelcomeView.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SwiftUI

extension Onboarding {
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
                        Heading(prefix: .l10n.welcomeLandingGreeting,
                                title: .l10n.welcomeLandingCallout)
                        TabView(selection: $page) {
                            Group {
                                Text(.l10n.welcomeLandingInfoFirst).tag(0)
                                Text(.l10n.welcomeLandingInfoSecond).tag(1)
                                Text(.l10n.welcomeLandingInfoThird).tag(2)
                            }
                            .modifier(InfoStyle())
                            .padding(.horizontal, .ds.s4)
                            .frame(greedy: .all, alignment: .topLeading)
                        }
                        .ignoresSafeArea()
                        .tabViewStyle(.page)
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
            WelcomeView(page: $_page, outlet: .inactive())
        }
    }

    struct WelcomeViewPreviews: PreviewProvider {
        static var previews: some View {
            WelcomeViewSample()
        }
    }
}
