//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

struct DesignSystemFont {
    let xxl: Font = .system(size: 30, weight: .bold, design: .rounded)
    let xl: Font = .system(size: 20, weight: .bold, design: .rounded)
    let lg: Font = .system(size: 16, weight: .bold, design: .rounded)
}

extension Font {
    static let ds: DesignSystemFont = .init()
}
