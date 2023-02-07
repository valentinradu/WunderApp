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
            .buttonStyle(OnboardingButtonStyle())
            .multilineTextAlignment(.leading)
            .frame(greedy: .all)
            .background(Color.ds.oceanBlue900)
            .safeAreaInset(.all, .ds.s4)
            .foregroundColor(.ds.white)
    }
}
