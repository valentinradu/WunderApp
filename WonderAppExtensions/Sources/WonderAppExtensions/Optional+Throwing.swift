//
//  File.swift
//
//
//  Created by Valentin Radu on 28/02/2023.
//

import Foundation

public extension Optional {
    func unwrapOr(error: Error) throws -> Wrapped {
        if let value = self {
            return value
        } else {
            throw error
        }
    }
}
