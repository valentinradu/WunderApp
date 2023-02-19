//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

private struct GreedyViewModifier: ViewModifier {
    private let _axis: Axis.Set
    private let _alignment: Alignment

    init(axis: Axis.Set, alignment: Alignment) {
        _axis = axis
        _alignment = alignment
    }

    func body(content: Content) -> some View {
        switch _axis {
        case .horizontal:
            content.frame(maxWidth: .infinity, alignment: _alignment)
        case .vertical:
            content.frame(maxHeight: .infinity, alignment: _alignment)
        case .all:
            content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: _alignment)
        default:
            content
        }
    }
}

private struct SafeAreaInsetModifier: ViewModifier {
    private let _axis: Axis.Set
    private let _length: CGFloat

    init(axis: Axis.Set, length: CGFloat) {
        _axis = axis
        _length = length
    }

    func body(content: Content) -> some View {
        let horizontally = _axis == .horizontal || _axis == .all
        let vertically = _axis == .vertical || _axis == .all
        content
            .safeAreaInset(edge: .trailing, spacing: 0) {
                if horizontally {
                    Color.clear.frame(width: _length)
                }
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                if horizontally {
                    Color.clear.frame(width: _length)
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                if vertically {
                    Color.clear.frame(height: _length)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if vertically {
                    Color.clear.frame(height: _length)
                }
            }
    }
}

public extension View {
    func frame(greedy axis: Axis.Set, alignment: Alignment = .center) -> some View {
        modifier(GreedyViewModifier(axis: axis, alignment: alignment))
    }
}

public extension View {
    func safeAreaInset(_ axis: Axis.Set, _ length: CGFloat) -> some View {
        modifier(SafeAreaInsetModifier(axis: axis, length: length))
    }
}

public extension Axis.Set {
    static var all: Axis.Set { [.vertical, .horizontal] }
}
