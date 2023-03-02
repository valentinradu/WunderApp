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
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: .ds.s6) {
            HeaderAnimation()
                .edgesIgnoringSafeArea(.horizontal)
                .overlay(alignment: .topLeading) {
                    Image.ds.logo
                }
            VStack(alignment: .center, spacing: .ds.s4) {
                DoubleHeading(prefix: .l10n.welcomeLandingGreeting,
                              title: .l10n.welcomeLandingCallout)
                PaginationCarousel(page: $viewModel.welcomePage) {
                    WelcomeTabItem(text: .l10n.welcomeLandingInfoFirst)
                    WelcomeTabItem(text: .l10n.welcomeLandingInfoSecond)
                    WelcomeTabItem(text: .l10n.welcomeLandingInfoThird)
                }
                .ignoresSafeArea(.all, edges: .horizontal)
                .safeAreaInset(edge: .bottom) {
                    PaginationIndicator(page: viewModel.welcomePage, of: 3)
                }
                .animation(.easeInOut, value: viewModel.welcomePage)
                Button {
                    viewModel.onInteraction(button: .towardsAskEmail)
                }
                    label: {
                    Text(.l10n.welcomeContinue)
                }
            }
        }
        .safeAreaInset(.all, .ds.s4)
        .frame(greedy: .all)
        .background(Color.ds.oceanBlue900)
        .foregroundColor(.ds.white)
        .buttonStyle(FormButtonStyle())
    }
}

private struct WelcomeViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        WelcomeView(viewModel: _model)
    }
}

struct WelcomeViewPreviews: PreviewProvider {
    static var previews: some View {
        WelcomeViewSample()
    }
}
