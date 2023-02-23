//
//  File.swift
//
//
//  Created by Valentin Radu on 23/02/2023.
//

import SwiftUI

private struct CountPreferenceKey: PreferenceKey {
    static var defaultValue: Int = 0

    static func reduce(value: inout Int, nextValue: () -> Int) {
        value += nextValue()
    }
}

private struct CountModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background {
            Color.clear
                .preference(key: CountPreferenceKey.self, value: 1)
        }
    }
}

public extension View {
    func countable() -> some View {
        modifier(CountModifier())
    }

    func sumUpCountableDescendants(perform action: @escaping (Int) -> Void) -> some View {
        onPreferenceChange(CountPreferenceKey.self, perform: action)
    }
}
