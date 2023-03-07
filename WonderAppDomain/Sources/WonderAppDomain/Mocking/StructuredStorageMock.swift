//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import AnyCodable
import Foundation
import WonderAppExtensions

public final class StructuredStorageMock: Codable, StructuredStorageProtocol {
    public enum Operation: Codable, Hashable {
        case create
        case read
        case update
        case delete
    }

    private var _results: [Operation: [AnyCodable: AnyCodable]]

    public func create<Q>(query: Q) async throws -> Q.Value where Q: StructuredStorageQuery {
        guard let result = _results[.create]?[AnyCodable(query)] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<Q.Value, ServiceError> else {
            fatalError()
        }

        return try await result.unwrap()
    }

    public func read<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
        guard let result = _results[.read]?[AnyCodable(query)] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<[Q.Value], ServiceError> else {
            fatalError()
        }

        return try await result.unwrap()
    }

    public func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws
        where Q: StructuredStorageQuery {
        guard let result = _results[.update]?[AnyCodable(query)] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<[Q.Value], ServiceError> else {
            fatalError()
        }

        for result in try await result.unwrap() {
            var mutatingResult = result
            perform(&mutatingResult)
        }
    }

    @discardableResult public func delete<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
        guard let result = _results[.delete]?[AnyCodable(query)] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<[Q.Value], ServiceError> else {
            fatalError()
        }

        return try await result.unwrap()
    }

    public func registerCreateResult<Q>(_ value: MockedResult<Q.Value, ServiceError>, for query: Q) throws
        where Q: StructuredStorageQuery {
        let newValues = [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.create] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.create] = newValues
        }
    }

    public func registerReadResults<Q>(_ value: MockedResult<[Q.Value], ServiceError>, for query: Q) throws
        where Q: StructuredStorageQuery {
        let newValues = [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.read] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.read] = newValues
        }
    }

    public func registerUpdateResults<Q>(_ value: MockedResult<[Q.Value], ServiceError>, for query: Q) throws
        where Q: StructuredStorageQuery {
        let newValues = [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.update] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.update] = newValues
        }
    }

    public func registerDeleteResults<Q>(_ value: MockedResult<[Q.Value], ServiceError>, for query: Q) throws
        where Q: StructuredStorageQuery {
        let newValues = [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.delete] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.delete] = newValues
        }
    }

    public func reset(operation: Operation) {
        _results[operation] = [:]
    }
}
