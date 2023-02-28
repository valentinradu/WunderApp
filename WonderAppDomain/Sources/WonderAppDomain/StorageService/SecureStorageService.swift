//
//  File.swift
//
//
//  Created by Valentin Radu on 28/02/2023.
//

import Foundation
import Security

actor SecureStorageService: StorageServiceProtocol {
    func fetch<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery {
        let decoder = JSONDecoder()

        let secureQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: query.hash,
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

    func save<Q>(query: Q, value: Q.Value) async throws where Q: StorageKeyValueQuery {
        let encoder = JSONEncoder()

        let data = try encoder.encode(value)

        let secureQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: query.hash,
            kSecValueData: data
        ] as [String: Any]

        SecItemDelete(secureQuery as CFDictionary)
        let status = SecItemAdd(secureQuery as CFDictionary, nil)

        if status != noErr {
            throw StorageServiceError.failedToSaveToUnderlyingStorage(query: query)
        }
    }

    @discardableResult func remove<Q>(query: Q) async throws -> Q.Value? where Q: StorageKeyValueQuery {
        guard let result = try? await fetch(query: query) else {
            // We don't need to throw in this case, the value we want to remove is already not present.
            return nil
        }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: query.hash
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        return result
    }
}
