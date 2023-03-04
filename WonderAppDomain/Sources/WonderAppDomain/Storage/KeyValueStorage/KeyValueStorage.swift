//
//  File.swift
//
//
//  Created by Valentin Radu on 01/03/2023.
//

import Foundation

public enum KeyValueStorageQueryTrait: Codable {
    case heavyweight
    case secure
    case ephemeral
}

public protocol KeyValueStorageQuery: Codable {
    associatedtype Value: Codable
    var trait: KeyValueStorageQueryTrait { get }
    var key: String { get }
}

public protocol KeyValueStorageProtocol {
    func create<Q>(query: Q, value: Q.Value) async throws where Q: KeyValueStorageQuery
    func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery
    func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery
    @discardableResult func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery
}

public enum KeyValueStorageError: Error {
    case failedToSaveToUnderlyingStorage(key: String)
    case failedToDecodeUnderlyingStorageValue(key: String)
    case failedToUpdateMissingItem(key: String)
}

private struct KeyValueStorageServiceKey: ServiceKey {
    static var defaultValue: KeyValueStorageProtocol = KeyValueStorage()
}

public extension Service.Repository {
    var keyValueStorage: KeyValueStorageProtocol {
        get { self[KeyValueStorageServiceKey.self] }
        set { self[KeyValueStorageServiceKey.self] = newValue }
    }
}

private actor KeyValueStorage: KeyValueStorageProtocol {
    private let _heavyweightKeyValueStorage = HeavyweightKeyValueStorage()
    private let _secureKeyValueStorage = SecureKeyValueStorage()
    private let _ephemeralKeyValueStorage = EphemeralKeyValueStorage()

    public func create<Q>(query: Q, value: Q.Value) async throws where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        try await storage.create(query: query, value: value)
    }

    public func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        return try await storage.read(query: query)
    }

    public func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws
        where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        try await storage.update(query: query, perform: perform)
    }

    @discardableResult public func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        return try await storage.delete(query: query)
    }

    private func _underlyingKeyValueStorage<Q>(for query: Q) -> KeyValueStorageProtocol where Q: KeyValueStorageQuery {
        switch query.trait {
        case .heavyweight:
            return _heavyweightKeyValueStorage
        case .secure:
            return _secureKeyValueStorage
        case .ephemeral:
            return _ephemeralKeyValueStorage
        }
    }
}
