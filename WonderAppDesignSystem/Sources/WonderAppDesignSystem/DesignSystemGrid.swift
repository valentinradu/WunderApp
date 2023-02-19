//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import Foundation

public struct DesignSystemGrid {
    // Spacings
    /// Space 1 point
    public let spt: CGFloat = 1
    /// Space 4 points
    public let s1: CGFloat = 4
    /// Space 8 points
    public let s2: CGFloat = 8
    /// Space 16 points
    public let s3: CGFloat = 16
    /// Space 24 points
    public let s4: CGFloat = 24
    /// Space 32 points
    public let s5: CGFloat = 32
    /// Space 48 points
    public let s6: CGFloat = 48
    /// Space 64 points
    public let s7: CGFloat = 64
    /// Space 96 points
    public let s8: CGFloat = 96

    // Dimension
    /// Dimension (width or height) 1 point
    public let dpt: CGFloat = 1
    /// Dimension (width or height) 24 points
    public let d1: CGFloat = 24
    /// Dimension (width or height) 40 points
    public let d2: CGFloat = 40
    /// Dimension (width or height) 80 points
    public let d3: CGFloat = 80
    /// Dimension (width or height) 120 points
    public let d4: CGFloat = 120
    /// Dmension (width or height) 180 points
    public let d5: CGFloat = 180
    /// Dimension (width or height) 240 points
    public let d6: CGFloat = 240
    /// Dimension (width or height) 300 points
    public let d7: CGFloat = 300
    /// Dimension (width or height) 320 points
    public let d8: CGFloat = 320
    /// Dimension (width or height) 400 points
    public let d9: CGFloat = 400

    // Border
    /// Border 1 point
    public let bpt: CGFloat = 1
    /// Border 2 point
    public let b1: CGFloat = 2
}

public extension CGFloat {
    static let ds: DesignSystemGrid = .init()
}
