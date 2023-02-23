//
//  File.swift
//
//
//  Created by Valentin Radu on 23/02/2023.
//

import SwiftUI

public struct PaginationIndicator: View {
    private var _page: Int
    @State private var _dynamicDiameter: CGFloat = .ds.s2
    private var _count: Int

    public init(page: Int, of count: Int) {
        _page = page
        _count = count
    }

    public var body: some View {
        HStack(spacing: .ds.s2) {
            ForEach(0 ..< _count, id: \.self) { i in
                Circle()
                    .fill(_color(for: i))
                    .frame(width: _diameter(for: i),
                           height: _diameter(for: i))
            }
        }
        .onChange(of: _page) { _ in
            withAnimation(.easeInOut) {
                _dynamicDiameter = .ds.s3
            }
            withAnimation(.easeInOut.delay(0.25)) {
                _dynamicDiameter = .ds.s2
            }
        }
    }

    private func _color(for index: Int) -> Color {
        index == _page ? .ds.white : .ds.white.opacity(0.4)
    }

    private func _diameter(for index: Int) -> CGFloat {
        index == _page ? _dynamicDiameter : .ds.s2
    }
}

private struct PaginationIndicatorSample: View {
    @State private var _page: Int = 0

    var body: some View {
        ZStack {
            PaginationIndicator(page: _page, of: 3)
        }
        .frame(greedy: .all)
        .background(Color.ds.oceanBlue900)
        .onTapGesture {
            _page = _page < 2 ? _page + 1 : 0
        }
    }
}

struct PaginationIndicatorPreviews: PreviewProvider {
    static var previews: some View {
        PaginationIndicatorSample()
    }
}
