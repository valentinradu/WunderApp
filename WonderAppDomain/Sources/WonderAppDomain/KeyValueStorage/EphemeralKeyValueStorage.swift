//
//  File.swift
//
//
//  Created by Valentin Radu on 01/03/2023.
//

import Foundation

actor EphemeralKeyValueStorage: KeyValueStorageProtocol {
    private var _rawStore: [String: Any] = [:]

    func create<Q>(query: Q) async throws -> Q.Value where Q: KeyValueStorageQuery {
        _rawStore[query.key] = query.defaultValue
        return query.defaultValue
    }

    func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let value = _rawStore[query.key]

        guard let value else {
            return nil
        }

        guard let value = value as? Q.Value else {
            throw KeyValueStorageError.failedToDecodeUnderlyingStorageValue(query: query)
        }

        return value
    }

    func update<Q>(query: Q, perform: (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery {
        let value = try await read(query: query)
        guard let value else {
            throw KeyValueStorageError.failedToUpdateMissingItem(query: query)
        }

        var newValue = value
        perform(&newValue)

        _rawStore[query.key] = newValue
    }

    @discardableResult func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        guard let value = try await read(query: query) else {
            return nil
        }

        _rawStore.removeValue(forKey: query.key)

        return value
    }
}
