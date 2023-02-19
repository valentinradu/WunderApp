//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

public enum ControlStatus: Codable, Hashable {
    case idle
    case loading
    case failure(message: String? = nil)
    case success(message: String? = nil)
}

private struct StatusEnvironmentKey: EnvironmentKey {
    static var defaultValue: ControlStatus = .idle
}

public extension EnvironmentValues {
    var controlStatus: ControlStatus {
        get { self[StatusEnvironmentKey.self] }
        set { self[StatusEnvironmentKey.self] = newValue }
    }
}
