//
//  File.swift
//
//
//  Created by Valentin Radu on 09/03/2023.
//

import os
import SwiftUI

private struct LoggerEnvironmentKey: EnvironmentKey {
    static var defaultValue: Logger = .init()
}

public extension EnvironmentValues {
    var logger: Logger {
        get { self[LoggerEnvironmentKey.self] }
        set { self[LoggerEnvironmentKey.self] = newValue }
    }
}
