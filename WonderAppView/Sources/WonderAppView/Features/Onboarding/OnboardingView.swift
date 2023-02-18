//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

enum Onboarding {}

extension OnboardingState {
    static let initial: OnboardingState = .init(form: .init(email: .empty,
                                                            fullName: .empty,
                                                            password: .empty,
                                                            newPassword: .empty,
                                                            focus: nil),
                                                path: .init(),
                                                welcomePage: 0)
}

struct OnboardingView: View {
    @State var state: OnboardingState = .initial
    var body: some View {
        OnboardingFragmentView(state: $state, fragment: .main)
    }
}

struct OnboardingViewSample: View {
    var body: some View {
        OnboardingView()
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingViewSample()
    }
}
