//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI

struct OnboardingInfoStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.ds.oceanGreen300)
            .font(.ds.xl)
            .bold(true)
    }
}
