//
//  File.swift
//
//
//  Created by Valentin Radu on 07/02/2023.
//

import SwiftUI

public extension RawRepresentable where Self: Codable {
    init?(rawValue: String) {
        let decoder = JSONDecoder()
        guard let data = rawValue.data(using: .utf8),
              let value = try? decoder.decode(Self.self, from: data)
        else {
            return nil
        }
        self = value
    }

    var rawValue: String {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self)
        assert(data != nil)
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
}