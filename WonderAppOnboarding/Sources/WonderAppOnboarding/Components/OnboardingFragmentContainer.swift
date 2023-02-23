//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI
import WonderAppDesignSystem

struct FragmentContainer<C>: View where C: View {
    private let _content: C
    @FocusState private var _focused

    init(@ViewBuilder _ contentBuilder: () -> C) {
        _content = contentBuilder()
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                _content
                    .buttonStyle(FormButtonStyle())
                    .focused($_focused)
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
