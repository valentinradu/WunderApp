//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import Foundation
import SwiftUI

enum SceneStorageKey {
    case welcomePage
    case onboardingNavigation
    case onboardingEmail
    case onboardingEmailStatus
}

extension SceneStorage {
    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value == Bool {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value == Int {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value == Double {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value == String {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value == URL {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value == Data {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, storageKey: SceneStorageKey) where Value: RawRepresentable,
        Value.RawValue == String {
        let key = String(describing: storageKey)
        self.init(wrappedValue: defaultValue, key)
    }
}
