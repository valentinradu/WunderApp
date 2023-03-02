//
//  File.swift
//
//
//  Created by Valentin Radu on 28/02/2023.
//

import Foundation

private extension URL {
    static var storageDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

actor HeavyweightKeyValueStorage: KeyValueStorageProtocol {
    private let _fileManager = FileManager.default

    func create<Q>(query: Q, value: Q.Value) async throws where Q: KeyValueStorageQuery {
        let encoder = JSONEncoder()
        let url = URL.storageDirectory.appendingPathComponent(query.key)
        let data = try encoder.encode(value)
        try data.write(to: url)
    }

    func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let decoder = JSONDecoder()

        let url = URL.storageDirectory.appendingPathComponent(query.key)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return try decoder.decode(Q.Value.self, from: data)
    }

    func update<Q>(query: Q, perform: (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery {
        let value = try await read(query: query)
        guard let value else {
            throw KeyValueStorageError.failedToUpdateMissingItem(key: query.key)
        }

        var newValue = value
        perform(&newValue)

        try await create(query: query, value: newValue)
    }

    @discardableResult func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let value = try await read(query: query)
        let url = URL.storageDirectory.appendingPathComponent(query.key)
        try _fileManager.removeItem(at: url)
        return value
    }
}
