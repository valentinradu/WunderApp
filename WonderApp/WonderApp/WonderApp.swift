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
    var body: some Scene {
        WindowGroup {
            let viewModel = OnboardingViewModel()
            OnboardingView(viewModel: viewModel)
                .overlay {
                    if let message = _message {
                        Text(verbatim: message)
                    }
                }
                .task {
                    do {
                        let suppliant = PeerSuppliant<MockPeerMessage>(target: "my-first-test", password: "pass")
                        await suppliant.discover()
                        let connection = try await suppliant.waitForConnection()

                        for await message in connection.messages.values {
                            switch message.kind {
                            case .test:
                                _message = String(data: message.data, encoding: .utf8)!
                            }
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
