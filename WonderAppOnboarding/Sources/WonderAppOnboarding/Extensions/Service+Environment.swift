//
//  File.swift
//
//
//  Created by Valentin Radu on 08/03/2023.
//

import SwiftUI
import WonderAppDomain

private struct ServiceRepositoryEnvironmentKey: EnvironmentKey {
    static var defaultValue: ServiceRepository = .init()
}

extension EnvironmentValues {
    var service: ServiceRepository {
        get { self[ServiceRepositoryEnvironmentKey.self] }
        set { self[ServiceRepositoryEnvironmentKey.self] = newValue }
    }
}
