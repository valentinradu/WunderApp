//
//  File.swift
//
//
//  Created by Valentin Radu on 23/02/2023.
//

import SwiftUI
import WonderAppExtensions

public struct PaginationCarousel<C>: View where C: View {
    @Binding private var _page: Int
    @State private var _count: Int = 0
    private let _content: C

    public init(page: Binding<Int>, @ViewBuilder contentBuilder: () -> C) {
        __page = page
        _content = contentBuilder()
    }

    public var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                _content
                    .countable()
                    .frame(width: geo.size.width)
            }
            .offset(x: _offset(pageSize: geo.size))
            .sumUpCountableDescendants {
                _count = $0
            }
        }
    }

    private func _offset(pageSize: CGSize) -> CGFloat {
        -CGFloat(min(_page, _count - 1)) * pageSize.width
    }
}

private struct PaginationCarouselSample: View {
    @State private var _page: Int = 0

    var body: some View {
        ZStack {
            PaginationCarousel(page: $_page) {
                Text(.samples.paragraph).padding()
                Text(.samples.paragraph).padding()
                Text(.samples.paragraph).padding()
            }
            .animation(.easeInOut, value: _page)
        }
        .frame(greedy: .all)
        .background(Color.ds.oceanBlue900)
        .onTapGesture {
            _page += 1
        }
    }
}

struct PaginationCarouselPreviews: PreviewProvider {
    static var previews: some View {
        PaginationCarouselSample()
    }
}
