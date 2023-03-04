//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation
import WonderAppExtensions

public extension Array where Element == Place {
    static let mocked: [Place] = [
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
}

public final class PlacesServiceMock: Codable, PlacesServiceProtocol {
    public var placesResult: MockedResult<[Place], ServiceError> = .success(value: .mocked, after: 0)

    public func findSuggestionsForUser() async throws -> [Place] {
        try await placesResult.unwrap()
    }

    public func toggleFavorite(id: Place.ID) async throws {
        let places = try await placesResult.unwrap().map {
            if $0.id == id {
                var newValue = $0
                newValue.isFavorite.toggle()
                return newValue
            } else {
                return $0
            }
        }

        placesResult = .success(value: places)
    }
}
