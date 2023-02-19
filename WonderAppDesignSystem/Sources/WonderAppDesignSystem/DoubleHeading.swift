//
//  File.swift
//
//
//  Created by Valentin Radu on 09/02/2023.
//

import SwiftUI
import WonderAppExtensions

public struct DoubleHeading: View {
    private let _prefix: AttributedString
    private let _title: AttributedString

    public init(prefix: AttributedString,
                title: AttributedString) {
        _prefix = prefix
        _title = title
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(_prefix)
                .font(.ds.lg)
                .foregroundColor(.ds.oceanBlue300)
            Text(_title)
                .font(.ds.xxl)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .bold(true)
        .foregroundColor(.ds.white)
        .frame(greedy: .horizontal, alignment: .leading)
    }
}
