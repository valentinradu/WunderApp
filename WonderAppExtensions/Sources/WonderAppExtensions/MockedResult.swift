//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation

public enum MockedResult<V, E>: Codable where V: Codable, E: Error, E: Codable {
    case failure(error: E, after: TimeInterval = 0)
    case success(value: V, after: TimeInterval = 0)
}

public enum MockedEmptyResult<E>: Codable where E: Error, E: Codable {
    case failure(error: E, after: TimeInterval = 0)
    case success(after: TimeInterval = 0)
}

public extension MockedResult {
    func unwrap() async throws -> V {
        switch self {
        case let .failure(error, after):
            try await Task.sleep(for: .seconds(after))
            throw error
        case let .success(value, after):
            try await Task.sleep(for: .seconds(after))
            return value
        }
    }
}

public extension MockedEmptyResult {
    func unwrap() async throws {
        switch self {
        case let .failure(error, after):
            try await Task.sleep(for: .seconds(after))
            throw error
        case let .success(after):
            try await Task.sleep(for: .seconds(after))
        }
    }
}
