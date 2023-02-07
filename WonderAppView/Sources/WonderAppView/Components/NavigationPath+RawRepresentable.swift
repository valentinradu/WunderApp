//
//  File.swift
//
//
//  Created by Valentin Radu on 31/01/2023.
//

import SwiftUI

extension NavigationPath: RawRepresentable {
    public init?(rawValue: String) {
        let decoder = JSONDecoder()
        guard let data = rawValue.data(using: .utf8),
              let value = try? decoder.decode(Self.self, from: data)
        else {
            return nil
        }
        self = value
    }

    public var rawValue: String {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self)
        assert(data != nil)
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
}
