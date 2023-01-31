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
}

extension SceneStorage {
    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == Bool {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == Int {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == Double {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == String {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == URL {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == Data {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }

    init(wrappedValue defaultValue: Value, _ key: SceneStorageKey) where Value == NavigationPath {
        let key = String(describing: key)
        self.init(wrappedValue: defaultValue, key)
    }
}
