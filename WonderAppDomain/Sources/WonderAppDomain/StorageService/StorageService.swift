//
//  File.swift
//
//
//  Created by Valentin Radu on 27/02/2023.
//

import CryptoKit
import Foundation

public enum StorageKeyValueQueryTrait {
    case lightweight
    case heavyweight
    case secure
    case ephemeral
}

public protocol StorageKeyValueQuery: Hashable {
    associatedtype Key: Codable
    associatedtype Value: Codable
    var key: Key { get }
    var trait: StorageKeyValueQueryTrait { get }
    var hash: String { get }
}

public extension StorageKeyValueQuery {
    var hash: String {
        key.hash
    }
}

enum StorageServiceError: Error {
    case failedToSaveToUnderlyingStorage(query: AnyHashable)
}

extension Encodable {
    var hash: String {
        let encoder = JSONEncoder()

        guard let keyData = try? encoder.encode(self) else {
            // TODO: error message
            fatalError()
        }

        return SHA256.hash(data: keyData).description
    }
}

public protocol StorageServiceProtocol {
    func fetch<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery
    func save<Q>(query: Q, value: Q.Value) async throws where Q: StorageKeyValueQuery
    @discardableResult func remove<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery
}

private struct StorageServiceKey: ServiceKey {
    static var defaultValue: StorageServiceProtocol = StorageService()
}

public extension Service.Repository {
    var storage: StorageServiceProtocol {
        get { self[StorageServiceKey.self] }
        set { self[StorageServiceKey.self] = newValue }
    }
}

public actor StorageService: StorageServiceProtocol {
    public func fetch<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery {
        let storage = _underlyingStorage(for: query)
        return try await storage.fetch(query: query)
    }

    public func save<Q>(query: Q, value: Q.Value) async throws where Q: StorageKeyValueQuery {
        let storage = _underlyingStorage(for: query)
        return try await storage.save(query: query, value: value)
    }

    @discardableResult public func remove<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery {
        let storage = _underlyingStorage(for: query)
        return try await storage.remove(query: query)
    }

    private func _underlyingStorage<Q>(for query: Q) -> StorageServiceProtocol where Q: StorageKeyValueQuery {
        switch query.trait {
        case .heavyweight:
            return HeavyweightStorageService()
        case .secure:
            return SecureStorageService()
        default:
            fatalError()
        }
    }
}
