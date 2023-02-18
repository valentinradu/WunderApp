//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI

struct OnboardingHeading: View {
    let prefix: AttributedString
    let title: AttributedString

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(prefix)
                .font(.ds.lg)
                .foregroundColor(.ds.oceanBlue300)
            Text(title)
                .font(.ds.xxl)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .bold(true)
        .foregroundColor(.ds.white)
        .frame(greedy: .horizontal, alignment: .leading)
    }
}
