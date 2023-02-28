//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppDesignSystem

private struct OnboardingFragmentView: View {
    @ObservedObject var model: OnboardingViewModel
    let fragment: FragmentName

    var body: some View {
        Group {
            switch fragment {
            case .main:
                OnboardingFragmentView(model: model, fragment: .welcome)
                    .navigationDestination(for: FragmentName.self) { fragment in
                        OnboardingFragmentView(model: model, fragment: fragment)
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
        .toolbar(.hidden, for: .navigationBar)
        .task {
            model.onPostAppear(fragment: fragment)
        }
    }
}

public struct OnboardingView: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    public init() {}

    public var body: some View {
        Group {
            if _model.isReady {
                NavigationStack(path: $_model.path) {
                    OnboardingFragmentView(model: _model, fragment: .main)
                }
            }
        }
        .task {
            await _model.prepare()
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
