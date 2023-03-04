//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation

public struct AnyCodable: Codable, @unchecked Sendable {
    enum CodingKeys: CodingKey {
        case mangledTypeName
        case baseData
    }

    public let base: Any
    public let baseData: Data
    public let mangledTypeName: String

    public init<V>(_ value: V) throws where V: Codable {
        base = value
        mangledTypeName = _mangledTypeName(V.self) ?? _typeName(V.self)

        let encoder = JSONEncoder()
        baseData = try encoder.encode(value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseData = try container.decode(Data.self, forKey: .baseData)
        mangledTypeName = try container.decode(String.self, forKey: .mangledTypeName)

        let jsonDecoder = JSONDecoder()
        guard let targetType = _typeByName(mangledTypeName) as? Decodable.Type else {
            throw DecodingError.typeMismatch(AnyCodable.self,
                                             DecodingError.Context(codingPath: container.codingPath,
                                                                   debugDescription: "Invalid encode type found",
                                                                   underlyingError: nil))
        }

        base = try jsonDecoder.decode(targetType, from: baseData)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseData, forKey: .baseData)
        try container.encode(mangledTypeName, forKey: .mangledTypeName)
    }
}

extension AnyCodable: Hashable {
    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        lhs.mangledTypeName == rhs.mangledTypeName &&
            lhs.baseData == rhs.baseData
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(mangledTypeName)
        hasher.combine(baseData)
    }
}
