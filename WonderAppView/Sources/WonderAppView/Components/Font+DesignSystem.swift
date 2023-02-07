//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

struct DesignSystemFont {
    /// 30pt, bold, rounded
    let xxl: Font = .system(size: 30, weight: .regular, design: .rounded)
    /// 20pt, bold, rounded
    let xl: Font = .system(size: 20, weight: .regular, design: .rounded)
    /// 16pt, bold, rounded
    let lg: Font = .system(size: 16, weight: .regular, design: .rounded)
    /// 12pt, bold, rounded
    let md: Font = .system(size: 14, weight: .regular, design: .rounded)
}

extension Font {
    static let ds: DesignSystemFont = .init()
}
