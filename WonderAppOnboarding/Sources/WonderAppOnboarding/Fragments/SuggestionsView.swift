//
//  File.swift
//
//
//  Created by Valentin Radu on 10/02/2023.
//

import Foundation
import SwiftUI
import WonderAppDesignSystem
import WonderAppExtensions

struct SuggestionsView: View {
    @Environment(\.navigationContext) private var _navigationContext

    var body: some View {
        EmptyView()
    }
}

private struct SuggestionsViewSample: View {
    var body: some View {
        SuggestionsView()
    }
}

struct SuggestionsViewPreviews: PreviewProvider {
    static var previews: some View {
        SuggestionsViewSample()
    }
}
