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

actor HeavyweightStorageService: StorageServiceProtocol {
    private let _fileManager = FileManager.default

    func fetch<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery {
        let decoder = JSONDecoder()

        let url = URL.storageDirectory.appendingPathComponent(query.hash)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return try decoder.decode(Q.Value.self, from: data)
    }

    func save<Q>(query: Q, value: Q.Value) async throws where Q: StorageKeyValueQuery {
        let encoder = JSONEncoder()
        let url = URL.storageDirectory.appendingPathComponent(query.hash)
        let data = try encoder.encode(value)
        try data.write(to: url)
    }

    @discardableResult func remove<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery {
        let result = try await fetch(query: query)
        let url = URL.storageDirectory.appendingPathComponent(query.hash)
        try _fileManager.removeItem(at: url)
        return result
    }
}
