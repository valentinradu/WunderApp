//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import Foundation

struct DesignSystemGrid {
    // Spacings
    /// 1 point
    let spt: CGFloat = 1
    /// 4 points
    let s1: CGFloat = 4
    /// 8 points
    let s2: CGFloat = 8
    /// 16 points
    let s3: CGFloat = 16
    /// 24 points
    let s4: CGFloat = 24
    /// 32 points
    let s5: CGFloat = 32
    /// 48 points
    let s6: CGFloat = 48
    /// 64 points
    let s7: CGFloat = 64
    /// 96 points
    let s8: CGFloat = 96

    // Dimension
    /// 1 point
    let dpt: CGFloat = 1
    /// 40 points
    let d1: CGFloat = 40
    /// 80 points
    let d2: CGFloat = 80
    /// 120 points
    let d3: CGFloat = 120
    /// 180 points
    let d4: CGFloat = 180
    /// 240 points
    let d5: CGFloat = 240
    /// 300 points
    let d6: CGFloat = 300
    /// 320 points
    let d7: CGFloat = 320
    /// 400 points
    let d8: CGFloat = 400

    // Border
    /// 2 point
    let b1: CGFloat = 2
}

extension CGFloat {
    static let ds: DesignSystemGrid = .init()
}
