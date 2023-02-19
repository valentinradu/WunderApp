//
//  WonderAppApp.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SwiftUI
import WonderAppOnboarding

@main
struct WonderApp: App {
    var body: some Scene {
        WindowGroup {
            Onboarding.OnboardingView()
        }
    }
}
