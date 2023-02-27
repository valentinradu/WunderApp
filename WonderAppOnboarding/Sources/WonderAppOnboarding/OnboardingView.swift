//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppDesignSystem

private struct OnboardingFragmentView: View {
    @ObservedObject var model: OnboardingModel
    let fragment: FragmentName

    var body: some View {
        Group {
            switch fragment {
            case .main:
                OnboardingFragmentView(model: model, fragment: .welcome)
                    .navigationDestination(for: FragmentName.self) { fragment in
                        OnboardingFragmentView(model: model, fragment: fragment)
                            .toolbar {
                                EmptyView()
                            }
                    }
            case .welcome:
                WelcomeView(model: model)
            case .askEmail:
                AskEmailView(model: model)
            case .askPassword:
                AskPasswordView(model: model)
            case .newAccount:
                NewAccountView(model: model)
            case .locateUser:
                LocateAccountView(model: model)
            case .suggestions:
                EmptyView()
            }
        }
        .task {
            model.postAppear(fragment: fragment)
        }
    }
}

public struct OnboardingView: View {
    @StateObject private var _model: OnboardingModel = .init()

    public init() {}

    public var body: some View {
        NavigationStack(path: $_model.path) {
            OnboardingFragmentView(model: _model, fragment: .main)
        }
        .userActivity(PersistentOnboardingUserActivity.model, isActive: true) { activity in
            _model.onUserActivity(activity)
        }
        .onContinueUserActivity(PersistentOnboardingUserActivity.model) { activity in
            _model.onContinueUserActivity(activity)
        }
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
