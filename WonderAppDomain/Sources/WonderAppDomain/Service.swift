//
//  File.swift
//
//
//  Created by Valentin Radu on 24/02/2023.
//

import Foundation

public protocol ServiceKey {
    associatedtype Value
    static var defaultValue: Value { get set }
}

public enum ServiceError: Error, Codable, Sendable {
    case unauthorized
    case wrongEmailOrPassword
    case invalidSignUpFields
}

public struct ServiceRepository {
    public init() {}
    public subscript<K>(key: K.Type) -> K.Value where K: ServiceKey {
        get { key.defaultValue }
        nonmutating set { key.defaultValue = newValue }
    }
}

@propertyWrapper
public struct Service<Value> {
    public typealias Repository = ServiceRepository

    public let wrappedValue: Value
    public let repository: Repository

    public init(_ keyPath: KeyPath<Repository, Value>) {
        repository = .init()
        wrappedValue = repository[keyPath: keyPath]
    }
}
