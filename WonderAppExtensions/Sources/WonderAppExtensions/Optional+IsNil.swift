//
//  File.swift
//
//
//  Created by Valentin Radu on 22/02/2023.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
