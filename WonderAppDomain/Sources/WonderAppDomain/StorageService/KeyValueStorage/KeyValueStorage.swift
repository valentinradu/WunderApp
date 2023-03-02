//
//  File.swift
//
//
//  Created by Valentin Radu on 01/03/2023.
//

import Foundation

public enum KeyValueStorageQueryTrait {
    case heavyweight
    case secure
    case ephemeral
}

public protocol KeyValueStorageQuery {
    associatedtype Value: Codable
    var trait: KeyValueStorageQueryTrait { get }
    var key: String { get }
}

public protocol KeyValueStorageProtocol {
    func create<Q>(query: Q, value: Q.Value) async throws where Q: KeyValueStorageQuery
    func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery
    func update<Q>(query: Q, perform: (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery
    @discardableResult func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery
}

public enum KeyValueStorageError: Error {
    case failedToSaveToUnderlyingStorage(key: String)
    case failedToDecodeUnderlyingStorageValue(key: String)
    case failedToUpdateMissingItem(key: String)
}
