//
//  File.swift
//
//
//  Created by Valentin Radu on 08/03/2023.
//

import SwiftUI

private struct PresentEnvironmentKey: EnvironmentKey {
    static var defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {
    var present: (AnyHashable) -> Void {
        get { self[PresentEnvironmentKey.self] }
        set { self[PresentEnvironmentKey.self] = newValue }
    }
}
