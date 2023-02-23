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

public extension ControlStatus {
    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }

    var isFailure: Bool {
        if case .failure = self {
            return true
        } else {
            return false
        }
    }
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
