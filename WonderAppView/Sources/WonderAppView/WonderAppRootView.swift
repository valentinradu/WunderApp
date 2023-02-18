//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

public struct WonderAppRootView: View {
    public init() {}

    public var body: some View {
        Onboarding.OnboardingView()
    }
}

struct WonderAppRootViewPreviews: PreviewProvider {
    static var previews: some View {
        WonderAppRootView()
    }
}
