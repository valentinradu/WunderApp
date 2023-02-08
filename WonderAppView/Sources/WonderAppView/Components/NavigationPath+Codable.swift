//
//  File.swift
//
//
//  Created by Valentin Radu on 07/02/2023.
//

import SwiftUI

extension NavigationPath: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try NavigationPath(container.decode(Self.CodableRepresentation))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(codable)
    }
}

extension NavigationPath: RawRepresentable {}
