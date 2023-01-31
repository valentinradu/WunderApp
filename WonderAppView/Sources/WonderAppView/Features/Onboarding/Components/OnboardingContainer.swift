//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

struct OnboardingContainer<C>: View where C: View {
    private let _content: C

    init(@ViewBuilder _ contentBuilder: () -> C) {
        _content = contentBuilder()
    }

    var body: some View {
        _content
            .buttonStyle(WelcomeButtonStyle())
            .multilineTextAlignment(.leading)
            .frame(greedy: .both)
            .background(Color.ds.oceanBlue900)
            .safeArea(.both, .ds.s4)
            .foregroundColor(.ds.white)
    }
}
