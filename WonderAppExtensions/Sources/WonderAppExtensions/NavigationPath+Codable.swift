//
//  File.swift
//
//
//  Created by Valentin Radu on 13/03/2023.
//

import SwiftUI

extension NavigationPath: Codable {
    enum CodingKeys: CodingKey {
        case codableRepresentation
    }

    public enum NavigationPathEncodingError: Error {
        case codableRepresentationNotEncodable
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codableRepresentation = try container.decode(
            NavigationPath.CodableRepresentation.self,
            forKey: .codableRepresentation
        )
        self = NavigationPath(codableRepresentation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let codableRepresentation = try codable
            .unwrapOr(error: NavigationPathEncodingError.codableRepresentationNotEncodable)
        try container.encode(codableRepresentation, forKey: .codableRepresentation)
    }
}
