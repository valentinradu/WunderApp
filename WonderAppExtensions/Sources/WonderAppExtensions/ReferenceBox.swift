//
//  File.swift
//
//
//  Created by Valentin Radu on 13/03/2023.
//

import Foundation

public final class ReferenceBox<T> {
    public var value: T

    public init(_ value: T) {
        self.value = value
    }
}
