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
        let data = Data(rawValue.utf8)
        guard let codable = try? decoder.decode(Self.CodableRepresentation, from: data) else {
            return nil
        }
        self = NavigationPath(codable)
    }

    public var rawValue: String {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(codable) {
            let value = String(data: data, encoding: .utf8)
            return value ?? ""
        } else {
            return ""
        }
    }
}
