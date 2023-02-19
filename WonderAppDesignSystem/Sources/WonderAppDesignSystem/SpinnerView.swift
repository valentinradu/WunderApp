//
//  File.swift
//
//
//  Created by Valentin Radu on 03/02/2023.
//

import SwiftUI

public struct SpinnerView: View {
    @State private var _loadingRotation: CGFloat = 0

    public var body: some View {
        Image.ds.largeButtonLoading
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.radians(_loadingRotation))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    _loadingRotation = .pi * 2
                }
            }
    }
}
