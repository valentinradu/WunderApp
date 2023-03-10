//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI
import WonderAppDesignSystem

struct FormContainer<C>: View where C: View {
    private let _content: C
    @FocusState private var _focused: Bool

    init(@ViewBuilder _ contentBuilder: () -> C) {
        _content = contentBuilder()
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                _content
                    .focused($_focused)
                    .buttonStyle(FormButtonStyle())
                    .multilineTextAlignment(.leading)
                    .safeAreaInset(.all, .ds.s4)
                    .frame(minHeight: geo.size.height)
                    .frame(greedy: .horizontal)
            }
            .background(Color.ds.oceanBlue900)
            .foregroundColor(.ds.white)
            .onTapGesture {
                _focused = false
            }
        }
    }
}
