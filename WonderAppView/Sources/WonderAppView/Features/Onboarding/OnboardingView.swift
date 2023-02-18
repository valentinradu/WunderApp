//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

enum Onboarding {}

extension Onboarding {
    struct OnboardingView: View {
        @State var state: ModelState = .initial
        var body: some View {
            FragmentView(state: $state, fragment: .main)
        }
    }

    private struct OnboardingViewSample: View {
        var body: some View {
            OnboardingView()
        }
    }

    struct OnboardingViewPreviews: PreviewProvider {
        static var previews: some View {
            OnboardingViewSample()
        }
    }
}
