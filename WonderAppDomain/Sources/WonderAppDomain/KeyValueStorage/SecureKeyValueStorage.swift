//
//  File.swift
//
//
//  Created by Valentin Radu on 28/02/2023.
//

import Foundation
import Security

actor SecureKeyValueStorage: KeyValueStorageProtocol {
    func create<Q>(query: Q) async throws -> Q.Value where Q: KeyValueStorageQuery {
        let value = query.defaultValue
        try _write(query: query, value: value)
        return value
    }

    func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        let decoder = JSONDecoder()

        let secureQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: query.key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(secureQuery as CFDictionary, &dataTypeRef)

        guard status == noErr, let data = dataTypeRef as? Data else {
            // We don't need to log this since it's expected when there is no value for the key.
            // A more advanced version would also check the status to make sure the error was not caused by something else.
            return nil
        }

        return try decoder.decode(Q.Value.self, from: data)
    }

    func update<Q>(query: Q, perform: (inout Q.Value) -> Void) async throws where Q: KeyValueStorageQuery {
        let value = try await read(query: query)
        guard let value else {
            throw KeyValueStorageError.failedToUpdateMissingItem(query: query)
        }

        var newValue = value
        perform(&newValue)
        try _write(query: query, value: newValue)
    }

    @discardableResult func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        guard let value = try? await read(query: query) else {
            // We don't need to throw in this case, the value we want to remove is already not present.
            return nil
        }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: query.key
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        return value
    }

    private func _write<Q>(query: Q, value: Q.Value) throws where Q: KeyValueStorageQuery {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)

        let secureQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: query.key,
            kSecValueData: data
        ] as [String: Any]

        SecItemDelete(secureQuery as CFDictionary)
        let status = SecItemAdd(secureQuery as CFDictionary, nil)

        if status != noErr {
            throw KeyValueStorageError.failedToSaveToUnderlyingStorage(query: query)
        }
    }
}
