//
//  File.swift
//
//
//  Created by Valentin Radu on 27/02/2023.
//

import CoreData
import CryptoKit
import Foundation

// MARK: Key value storage

public enum KeyValueStorageQueryTrait {
    case heavyweight
    case secure
    case ephemeral
}

public protocol KeyValueStorageQuery: Hashable {
    associatedtype Value: Codable
    var trait: KeyValueStorageQueryTrait { get }
    var key: String { get }
    var defaultValue: Value { get }
}

public protocol KeyValueStorageProtocol {
    func create<Q>(query: Q) async throws -> Q.Value where Q: KeyValueStorageQuery
    func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery
    func update<Q>(query: Q, perform: (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery
    @discardableResult func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery
}

public enum KeyValueStorageError: Error {
    case failedToSaveToUnderlyingStorage(query: AnyHashable)
    case failedToDecodeUnderlyingStorageValue(query: AnyHashable)
    case failedToUpdateMissingItem(query: AnyHashable)
}

private struct KeyValueStorageServiceKey: ServiceKey {
    static var defaultValue: KeyValueStorageProtocol = KeyValueStorage()
}

public extension Service.Repository {
    var storageService: KeyValueStorageProtocol {
        get { self[KeyValueStorageServiceKey.self] }
        set { self[KeyValueStorageServiceKey.self] = newValue }
    }
}

public actor KeyValueStorage: KeyValueStorageProtocol {
    private let _heavyweightKeyValueStorage = HeavyweightKeyValueStorage()
    private let _secureKeyValueStorage = SecureKeyValueStorage()
    private let _ephemeralKeyValueStorage = EphemeralKeyValueStorage()

    public func create<Q>(query: Q) async throws -> Q.Value where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        return try await storage.create(query: query)
    }

    public func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        return try await storage.read(query: query)
    }

    public func update<Q>(query: Q, perform: (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery {
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
