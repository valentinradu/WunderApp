//
//  File.swift
//
//
//  Created by Valentin Radu on 10/02/2023.
//

import Foundation
import SwiftUI
import WonderAppDesignSystem

struct SuggestionsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        EmptyView()
    }
}

private struct SuggestionsViewSample: View {
    @StateObject private var _model: OnboardingViewModel = .init()

    var body: some View {
        SuggestionsView(viewModel: _model)
    }
}

struct SuggestionsViewPreviews: PreviewProvider {
    static var previews: some View {
        SuggestionsViewSample()
    }
}
