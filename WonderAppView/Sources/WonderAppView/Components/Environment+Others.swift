//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

private struct IsLoadingEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[IsLoadingEnvironmentKey.self] }
        set { self[IsLoadingEnvironmentKey.self] = newValue }
    }
}
