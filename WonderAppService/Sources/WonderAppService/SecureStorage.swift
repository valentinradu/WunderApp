//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

// import Security

// @propertyWrapper
// struct SecureStorage<Value>: DynamicProperty where Value: Codable {
//    private let _defaultValue: Value
//    private let _key: String
//
//    init(wrappedValue: Value, _ key: String) {
//        _defaultValue = wrappedValue
//        _key = key
//    }
//
//    var wrappedValue: Value {
//        get {
//            print("fetching secure data!")
//            let query = [
//                kSecClass: kSecClassGenericPassword,
//                kSecAttrAccount: _key,
//                kSecReturnData: true,
//                kSecMatchLimit: kSecMatchLimitOne
//            ] as [String: Any]
//
//            var dataTypeRef: AnyObject?
//            let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//
//            let decoder = JSONDecoder()
//            if status == noErr,
//               let data = dataTypeRef as? Data,
//               let result = try? decoder.decode(Value.self, from: data) {
//                return result
//            } else {
//                return _defaultValue
//            }
//        }
//
//        nonmutating set {
//            let encoder = JSONEncoder()
//            guard let data = try? encoder.encode(newValue) else {
//                assertionFailure("Failed to encode secure value")
//                return
//            }
//
//            let query = [
//                kSecClass: kSecClassGenericPassword,
//                kSecAttrAccount: _key,
//                kSecValueData: data
//            ] as [String: Any]
//
//            SecItemDelete(query as CFDictionary)
//            let status = SecItemAdd(query as CFDictionary, nil)
//            assert(status == noErr)
//        }
//    }
//
//    var projectedValue: Binding<Value> {
//        Binding {
//            wrappedValue
//        } set: { value in
//            wrappedValue = value
//        }
//    }
// }
