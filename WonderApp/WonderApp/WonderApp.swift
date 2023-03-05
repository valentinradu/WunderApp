//
//  WonderAppApp.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SwiftUI
import WonderAppExtensions
import WonderAppOnboarding

@main
struct WonderApp: App {
    @State private var _message: String?
    @State private var _connection: PeerConnection?
    var body: some Scene {
        WindowGroup {
            let viewModel = OnboardingViewModel()
            OnboardingView(viewModel: viewModel)
                .task {
                    do {
                        let browser = PeerBrowser(target: "my-first-test")
                        try await browser.discover()
                        _connection = try await browser.waitForConnection()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
