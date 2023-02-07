//
//  WelcomeView.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SwiftUI

struct WelcomeView: View {
    @SceneStorage(storageKey: .welcomePage) private var _page = 0
    @Environment(\.present) private var _present

    var body: some View {
        OnboardingContainer {
            VStack(spacing: .ds.s6) {
                WelcomeHeader()
                    .edgesIgnoringSafeArea(.horizontal)
                    .overlay(alignment: .topLeading) {
                        Image.ds.logo
                    }
                VStack(alignment: .center, spacing: .ds.s4) {
                    VStack(alignment: .leading, spacing: .ds.s4) {
                        VStack(alignment: .leading) {
                            Text(.l10n.welcomeLandingGreeting)
                                .font(.ds.lg)
                                .bold(true)
                                .foregroundColor(.ds.oceanBlue300)
                            Text(.l10n.welcomeLandingCallout)
                                .font(.ds.xxl)
                                .bold(true)
                        }
                        .frame(greedy: .horizontal, alignment: .leading)
                    }
                    TabView(selection: $_page) {
                        Group {
                            Text(.l10n.welcomeLandingInfoFirst).tag(0)
                            Text(.l10n.welcomeLandingInfoSecond).tag(1)
                            Text(.l10n.welcomeLandingInfoThird).tag(2)
                        }
                        .padding(.horizontal, .ds.s4)
                        .frame(greedy: .all, alignment: .topLeading)
                        .foregroundColor(.ds.oceanGreen300)
                    }
                    .ignoresSafeArea()
                    .font(.ds.xl)
                    .bold(true)
                    .tabViewStyle(.page)
                    .animation(.easeInOut, value: _page)
                    Button {
                        _onContinueTap()
                    } label: {
                        Text(.l10n.welcomeContinue)
                    }
                }
            }
        }
    }

    private func _onContinueTap() {
        if _page == 2 {
            _present(OnboardingFragment.askEmail)
        } else {
            _page += 1
        }
    }
}

struct WelcomeViewPreviews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
