//
//  File.swift
//
//
//  Created by Valentin Radu on 27/02/2023.
//

import CoreData
import CryptoKit
import Foundation

private struct StorageServiceKey: ServiceKey {
    static var defaultValue: StorageServiceProtocol = StorageService()
}

public typealias StorageServiceProtocol = KeyValueStorageProtocol & StructuredStorageProtocol

public extension Service.Repository {
    var storageService: StorageServiceProtocol {
        get { self[StorageServiceKey.self] }
        set { self[StorageServiceKey.self] = newValue }
    }
}

public actor StorageService: StorageServiceProtocol {
    private let _heavyweightKeyValueStorage = HeavyweightKeyValueStorage()
    private let _secureKeyValueStorage = SecureKeyValueStorage()
    private let _ephemeralKeyValueStorage = EphemeralKeyValueStorage()
    private let _structuredStorage = StructuredStorage()

    public func create<Q>(query: Q, value: Q.Value) async throws where Q: KeyValueStorageQuery {
        let storage = _underlyingKeyValueStorage(for: query)
        try await storage.create(query: query, value: value)
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

    public func create<Q>(query: Q) async throws -> Q.Value where Q: StructuredStorageQuery {
        try await _structuredStorage.create(query: query)
    }

    public func read<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
        try await _structuredStorage.read(query: query)
    }

    public func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws
        where Q: StructuredStorageQuery {
        try await _structuredStorage.update(query: query, perform: perform)
    }

    @discardableResult public func delete<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
        try await _structuredStorage.delete(query: query)
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
