//
//  File.swift
//
//
//  Created by Valentin Radu on 04/03/2023.
//
import Foundation
import WonderAppExtensions

private extension KeyValueStorageQuery {
    func toAnyCodable() -> AnyCodable {
        do {
            return try AnyCodable(self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

public final class KeyValueStorageMock: Codable, KeyValueStorageProtocol {
    public enum Operation: Codable, Hashable {
        case create
        case read
        case update
        case delete
    }

    private var _results: [Operation: [AnyCodable: AnyCodable]]

    public func create<Q>(query: Q, value: Q.Value) async throws where Q: KeyValueStorageQuery {
        guard let result = _results[.create]?[query.toAnyCodable()] else {
            fatalError()
        }

        guard let result = result.base as? MockedEmptyResult<ServiceError> else {
            fatalError()
        }

        try await result.unwrap()
    }

    public func read<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        guard let result = _results[.read]?[query.toAnyCodable()] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<Q.Value?, ServiceError> else {
            fatalError()
        }

        return try await result.unwrap()
    }

    public func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws
        where Q: KeyValueStorageQuery {
        guard let result = _results[.update]?[query.toAnyCodable()] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<Q.Value, ServiceError> else {
            fatalError()
        }

        var mutatingResult = try await result.unwrap()
        perform(&mutatingResult)
    }

    @discardableResult public func delete<Q>(query: Q) async throws -> Q.Value? where Q: KeyValueStorageQuery {
        guard let result = _results[.delete]?[query.toAnyCodable()] else {
            fatalError()
        }

        guard let result = result.base as? MockedResult<Q.Value?, ServiceError> else {
            fatalError()
        }

        return try await result.unwrap()
    }

    public func registerCreateResult<Q>(_ value: MockedEmptyResult<ServiceError>, for query: Q) throws
        where Q: KeyValueStorageQuery {
        let newValues = try [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.create] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.create] = newValues
        }
    }

    public func registerReadResults<Q>(_ value: MockedResult<Q.Value?, ServiceError>, for query: Q) throws
        where Q: KeyValueStorageQuery {
        let newValues = try [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.read] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.read] = newValues
        }
    }

    public func registerUpdateResults<Q>(_ value: MockedResult<Q.Value, ServiceError>, for query: Q) throws
        where Q: KeyValueStorageQuery {
        let newValues = try [AnyCodable(query): AnyCodable(value)]
        if let results = _results[.create] {
            _results[.update] = results
                .merging(newValues, uniquingKeysWith: { _, b in b })
        } else {
            _results[.update] = newValues
        }
    }

    public func registerDeleteResults<Q>(_ value: MockedResult<Q.Value?, ServiceError>, for query: Q) throws
        where Q: KeyValueStorageQuery {
        let newValues = try [AnyCodable(query): AnyCodable(value)]
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
