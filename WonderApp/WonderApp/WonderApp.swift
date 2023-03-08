//
//  WonderAppApp.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SwiftUI
import WonderAppDomain
import WonderAppOnboarding

@main
struct WonderApp: App {
    #if TESTING
        @Service(\.mocking) private var _mockingService
    #endif
    var body: some Scene {
        WindowGroup {
            let viewModel = OnboardingViewModel()
            OnboardingView(viewModel: viewModel)
                .task {
                    #if TESTING
                        do {
                            try await _mockingService.awaitMocks()
                        } catch {
                            assertionFailure(error.localizedDescription)
                        }
                    #endif
                }
        }
    }
}
