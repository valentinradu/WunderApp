//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import Foundation
import WonderAppExtensions

public struct Place: Codable, @unchecked Sendable {
    public struct ID: Codable, Sendable, Equatable {
        private let _rawValue: String
        public init(_ rawValue: String) {
            _rawValue = rawValue
        }
    }

    public enum Activity: Codable, Sendable {
        case camping
        case sailing
        case hiking
    }

    public let id: ID
    public let name: String
    public let distance: Measurement<UnitLength>
    public let activities: [Activity]
    public var isFavorite: Bool
    public let coverURL: URL
}

private struct PlacesServiceKey: ServiceKey {
    static var defaultValue: PlacesServiceProtocol = PlacesService()
}

public extension Service.Repository {
    var places: PlacesServiceProtocol {
        set { self[PlacesServiceKey.self] = newValue }
        get { self[PlacesServiceKey.self] }
    }
}

public protocol PlacesServiceProtocol {
    func findSuggestionsForUser() async throws -> [Place]
    func toggleFavorite(id: Place.ID) async throws
}

public actor PlacesService: PlacesServiceProtocol {
    public func findSuggestionsForUser() async throws -> [Place] {
        fatalError("Not implemented")
    }

    public func toggleFavorite(id: Place.ID) async throws {
        fatalError("Not implemented")
    }
}
