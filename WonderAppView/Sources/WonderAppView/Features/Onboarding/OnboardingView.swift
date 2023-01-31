//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

enum OnboardingFragment {
    case welcome
    case askEmail
    case askPassword
    case createAccount
    case locateUser
    case suggestions
}

struct OnboardingView: View {
    @SceneStorage(.onboardingNavigation) private var _path = NavigationPath()

    var body: some View {
        NavigationStack(path: $_path) {
            WelcomeView()
                .navigationDestination(for: OnboardingFragment.self) { fragment in
                    Group {
                        switch fragment {
                        case .welcome:
                            WelcomeView()
                        case .askEmail:
                            AskEmailView()
                        case .askPassword:
                            EmptyView()
                        case .createAccount:
                            EmptyView()
                        case .locateUser:
                            EmptyView()
                        case .suggestions:
                            EmptyView()
                        }
                    }
                    .toolbar {
                        EmptyView()
                    }
                }
        }
        .environment(\.present) { fragment in
            _path.append(fragment)
        }
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
