//
//  File.swift
//
//
//  Created by Valentin Radu on 13/02/2023.
//

import Foundation

struct AnyError: Error, Hashable {
    let underlyingError: Error
    init<E>(_ error: E) where E: Error {
        if let error = error as? AnyError {
            self = error
        } else {
            underlyingError = error
        }
    }

    static func == (lhs: AnyError, rhs: AnyError) -> Bool {
        lhs.underlyingError.localizedDescription == rhs.underlyingError.localizedDescription
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(underlyingError.localizedDescription)
    }
}
