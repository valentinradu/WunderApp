//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

public enum ControlStatus: Hashable {
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

private struct ControlStatusEnvironmentKey: EnvironmentKey {
    static var defaultValue: ControlStatus = .idle
}

public extension EnvironmentValues {
    var controlStatus: ControlStatus {
        get { self[ControlStatusEnvironmentKey.self] }
        set { self[ControlStatusEnvironmentKey.self] = newValue }
    }
}
