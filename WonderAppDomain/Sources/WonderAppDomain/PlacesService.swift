//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import Foundation
import WonderAppExtensions

public struct Place {
    public struct ID: Equatable {
        private let _rawValue: String
        public init(_ rawValue: String) {
            _rawValue = rawValue
        }
    }

    public enum Activity {
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

//private extension StringSample {
//    var yosemiteNationalPark: String {  }
//    var lakeTahoe: String { "Lake Tahoe" }
//    var bigSur: String { "Big Sur" }
//    var redwood: String { "Redwood" }
//}
//
//private extension URLSample {
//    var yosemiteNationalParkCoverURL: URL { Bundle.module.url(forResource: "", withExtension: "jpg")! }
//    var lakeTahoeCoverURL: URL { Bundle.module.url(forResource: "", withExtension: "jpg")! }
//    var bigSurCoverURL: URL { Bundle.module.url(forResource: "", withExtension: "jpg")! }
//    var bigSurCoverURL: URL { Bundle.module.url(forResource: "", withExtension: "jpg")! }
//}

public actor PlacesServiceSample: PlacesServiceProtocol {
    public var places: [Place] = [
        .init(id: .init("0"),
              name: "Yosemite National Park",
              distance: .init(value: 128, unit: .kilometers),
              activities: [.camping],
              isFavorite: false,
              coverURL: Bundle.module.url(forResource: "elcapitan", withExtension: "jpg")!),
        .init(id: .init("1"),
              name: "Lake Tahoe",
              distance: .init(value: 80, unit: .kilometers),
              activities: [.camping, .sailing],
              isFavorite: false,
              coverURL: Bundle.module.url(forResource: "laketahoe", withExtension: "jpg")!),
        .init(id: .init("2"),
              name: "Big Sur",
              distance: .init(value: 73, unit: .kilometers),
              activities: [.camping],
              isFavorite: false,
              coverURL: Bundle.module.url(forResource: "bigsur", withExtension: "jpg")!),
        .init(id: .init("3"),
              name: "Redwood national park",
              distance: .init(value: 121, unit: .kilometers),
              activities: [.hiking],
              isFavorite: false,
              coverURL: Bundle.module.url(forResource: "redwood", withExtension: "jpg")!)
    ]

    public func findSuggestionsForUser() async throws -> [Place] {
        places
    }

    public func toggleFavorite(id: Place.ID) async throws {
        places = places.map {
            if $0.id == id {
                var newValue = $0
                newValue.isFavorite.toggle()
                return newValue
            }
            else {
                return $0
            }
        }
    }
}
