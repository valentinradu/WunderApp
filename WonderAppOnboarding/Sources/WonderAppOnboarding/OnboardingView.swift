//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppDesignSystem

private struct OnboardingFragmentView: View {
    private let _modelActivityName: String = "com.wonderapp.activity.onboarding.model"
    @FocusState private var _focused: FormFieldName?
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
                AskEmailView(email: $model.form.email,
                             canMoveToNextStep: model.canPresent(fragment: .newAccount),
                             outlet: model.askEmailFragmentOutlet)
                    .focused($_focused, equals: .email)
            case .askPassword:
                AskPasswordView(password: $model.form.password,
                                canLogin: model.canLogin,
                                outlet: model.askPasswordFragmentOutlet)
                    .focused($_focused, equals: .password)
            case .newAccount:
                NewAccountView(fullName: $model.form.fullName,
                               newPassword: $model.form.newPassword,
                               canSignUp: model.canSignUp,
                               outlet: model.newAccountFragmentOutlet)
                    .focused($_focused, equals: .fullName)
            case .locateUser:
                LocateAccountView(outlet: model.locateMeFragmentOutlet)
            case .suggestions:
                EmptyView()
            }
        }
        .onAppear {
            model.onAppear(fragment: fragment)
        }
        .userActivity(_modelActivityName) { activity in
            model.save(to: activity)
        }
        .onContinueUserActivity(_modelActivityName) { activity in
            model.restore(from: activity)
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
