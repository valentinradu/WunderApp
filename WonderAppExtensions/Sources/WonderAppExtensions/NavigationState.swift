//
//  File.swift
//
//
//  Created by Valentin Radu on 13/03/2023.
//

import Foundation
import SwiftUI

private struct NavigationContextEnvironmentKey: EnvironmentKey {
    static var defaultValue: NavigationContext = .constant
}

public extension EnvironmentValues {
    var navigationContext: NavigationContext {
        get { self[NavigationContextEnvironmentKey.self] }
        set { self[NavigationContextEnvironmentKey.self] = newValue }
    }
}

public struct NavigationContext {
    @Binding private var _path: NavigationPath

    public static let constant: NavigationContext = .init(path: .constant(.init()))

    public init(path: Binding<NavigationPath>) {
        __path = path
    }

    public func present<F>(fragment: F) where F: Hashable, F: Codable {
        _path.append(fragment)
    }

    public func dismiss(_ k: Int = 1) {
        _path.removeLast(k)
    }
}
