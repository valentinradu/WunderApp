//
//  File.swift
//
//
//  Created by Valentin Radu on 13/02/2023.
//

import Foundation

public struct AnyError: Error, Hashable {
    public let underlyingError: Error

    fileprivate init<E>(_ error: E) where E: Error {
        if let error = error as? AnyError {
            self = error
        } else {
            underlyingError = error
        }
    }

    public func `as`<E>(_ type: E.Type) -> E? where E: Error {
        underlyingError as? E
    }

    public static func == (lhs: AnyError, rhs: AnyError) -> Bool {
        lhs.underlyingError.localizedDescription == rhs.underlyingError.localizedDescription
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(underlyingError.localizedDescription)
    }
}

public extension Error {
    var asAnyError: AnyError {
        AnyError(self)
    }
}
