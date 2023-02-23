//
//  File.swift
//
//
//  Created by Valentin Radu on 23/02/2023.
//

import SwiftUI

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize?

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

private struct MeasureSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geo in
                Color.clear
                    .anchorPreference(key: SizePreferenceKey.self,
                                      value: .bounds,
                                      transform: {
                                          geo[$0].size
                                      })
            }
        }
    }
}

public extension View {
    func measure(perform action: @escaping (CGSize?) -> Void) -> some View {
        modifier(MeasureSizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}
