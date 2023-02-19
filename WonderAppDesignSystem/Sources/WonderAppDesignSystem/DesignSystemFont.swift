//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

public struct DesignSystemFont {
    /// 30pt, bold, rounded
    public let xxl: Font = .system(size: 30, weight: .regular, design: .rounded)
    /// 20pt, bold, rounded
    public let xl: Font = .system(size: 20, weight: .regular, design: .rounded)
    /// 16pt, bold, rounded
    public let lg: Font = .system(size: 16, weight: .regular, design: .rounded)
    /// 12pt, bold, rounded
    public let md: Font = .system(size: 14, weight: .regular, design: .rounded)
}

public extension Font {
    static let ds: DesignSystemFont = .init()
}
