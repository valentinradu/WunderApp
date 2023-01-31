//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

typealias PresentAction = (any Hashable) -> Void

private struct PresentEnvironmentKey: EnvironmentKey {
    static var defaultValue: PresentAction = { _ in }
}

extension EnvironmentValues {
    var present: PresentAction {
        get { self[PresentEnvironmentKey.self] }
        set { self[PresentEnvironmentKey.self] = newValue }
    }
}
