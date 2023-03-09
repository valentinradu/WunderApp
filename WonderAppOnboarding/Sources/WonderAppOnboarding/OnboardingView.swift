//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

private struct OnboardingFragmentView: View {
    @State private var _form: FormViewModel = .init()
    @State private var _toastMessage: String?
    let fragment: FragmentName

    var body: some View {
        Group {
            switch fragment {
            case .main:
                OnboardingFragmentView(fragment: .welcome)
                    .navigationDestination(for: FragmentName.self) { fragment in
                        OnboardingFragmentView(fragment: fragment)
                    }
            case .welcome:
                WelcomeView()
            case .askEmail:
                AskEmailView(form: $_form)
            case .askPassword:
                AskPasswordView(form: $_form)
            case .newAccount:
                NewAccountView(form: $_form)
            case .locateUser:
                LocateAccountView()
            case .suggestions:
                SuggestionsView()
            }
        }
        .toast($_toastMessage) { message in
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
    }
}

public struct OnboardingView: View {
    @State private var _path: [FragmentName] = []
    @State private var _isReady: Bool = false
    @StateObject private var _taskPlanner: TaskPlanner<AnyHashable> = .init()

    public init() {}

    public var body: some View {
        Group {
            if _isReady {
                NavigationStack(path: $_path) {
                    OnboardingFragmentView(fragment: .main)
                }
            }
        }
        .environment(\.present) {
            guard let fragment = $0 as? FragmentName else {
                assertionFailure()
                return
            }
            _path.append(fragment)
        }
        .environment(\.dispatch) { name, action in
            _taskPlanner.perform(name, action: action)
        }
        .task {
            _isReady = true
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

//
// private func _save() async {
//    let persistentViewModel = PersistentOnboardingViewModel(email: form.email.value,
//                                                            fullName: form.fullName.value,
//                                                            path: path,
//                                                            welcomePage: welcomePage,
//                                                            focus: form.focus)
//    do {
//        try await _keyValueStorage.create(query: .onboardingViewModel, value: persistentViewModel)
//    } catch {
//        assertionFailure()
//        // TODO: Log
//    }
// }
//
// private func _attemptToRestore() async {
//    guard let persistentViewModel = try? await _keyValueStorage.read(query: .onboardingViewModel) else {
//        return
//    }
//
//    let validator = InputValidator()
//    form.email = .init(value: persistentViewModel.email,
//                       status: .idle,
//                       isRedacted: false,
//                       validator: validator.validate(email:))
//    form.fullName = .init(value: persistentViewModel.fullName,
//                          status: .idle,
//                          isRedacted: false,
//                          validator: validator.validate(name:))
//    form.validate()
//
//    path = persistentViewModel.path
//    welcomePage = persistentViewModel.welcomePage
//    form.focus = persistentViewModel.focus
// }
