//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import Foundation

public struct Place {
    public struct ID {
        private let _rawValue: String
        public init(_ rawValue: String) {
            _rawValue = rawValue
        }
    }

    public enum Activity {
        case camping
        case sailing
    }

    public let id: ID
    public let name: String
    public let distance: Measurement<UnitLength>
    public let activity: Activity
    public let isFavorite: Bool
    public let coverURL: URL
}

private struct PlacesServiceKey: ServiceKey {
    static var defaultValue: PlacesServiceProtocol = PlacesService()
}

public protocol PlacesServiceProtocol {
    func findSuggestionsForUser() async throws -> [Place]
    func toggleFavorite(id: Place.ID) async throws
}

private actor PlacesService: PlacesServiceProtocol {
    func findSuggestionsForUser() async throws -> [Place] {
        []
    }

    func toggleFavorite(id: Place.ID) async throws {}
}
