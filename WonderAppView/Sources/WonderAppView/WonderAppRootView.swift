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
        OnboardingView()
    }
}

public struct WonderAppRootViewPreviews: PreviewProvider {
    public static var previews: some View {
        WonderAppRootView()
    }
}
