//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppDesignSystem

private struct OnboardingFragmentView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let fragment: FragmentName

    var body: some View {
        Group {
            switch fragment {
            case .main:
                OnboardingFragmentView(viewModel: viewModel, fragment: .welcome)
                    .navigationDestination(for: FragmentName.self) { fragment in
                        OnboardingFragmentView(viewModel: viewModel, fragment: fragment)
                    }
            case .welcome:
                WelcomeView(viewModel: viewModel)
            case .askEmail:
                AskEmailView(viewModel: viewModel)
            case .askPassword:
                AskPasswordView(viewModel: viewModel)
            case .newAccount:
                NewAccountView(viewModel: viewModel)
            case .locateUser:
                LocateAccountView(viewModel: viewModel)
            case .suggestions:
                SuggestionsView(viewModel: viewModel)
            }
        }
        .toast($viewModel.toastMessage) { message in
            Text(verbatim: message)
                .frame(greedy: .horizontal)
                .padding(.ds.d1)
                .background {
                    RoundedRectangle(cornerRadius: .ds.r1)
                        .fill(Color.ds.oceanBlue400)
                }
                .foregroundColor(.ds.white)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            viewModel.onPostAppear(fragment: fragment)
        }
    }
}

public struct OnboardingView: View {
    @ObservedObject private var _viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        _viewModel = viewModel
    }

    public var body: some View {
        Group {
            if _viewModel.isReady {
                NavigationStack(path: $_viewModel.path) {
                    OnboardingFragmentView(viewModel: _viewModel, fragment: .main)
                }
            }
        }
        .task {
            await _viewModel.prepare()
        }
    }
}

private struct OnboardingViewSample: View {
    @StateObject private var _viewModel: OnboardingViewModel = .init()

    var body: some View {
        OnboardingView(viewModel: _viewModel)
            .onAppear {
                _viewModel.toastMessage = .samples.paragraph
            }
    }
}

struct OnboardingViewPreviews: PreviewProvider {
    static var previews: some View {
        OnboardingViewSample()
    }
}
