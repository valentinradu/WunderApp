//
//  File.swift
//
//
//  Created by Valentin Radu on 01/03/2023.
//

import CoreData
import Foundation

private extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
}

public protocol StructuredStorageQuery {
    associatedtype Value: NSManagedObject
    var request: NSFetchRequest<Value> { get }
    func defaultValue(context: NSManagedObjectContext) -> Value
}

public protocol StructuredStorageProtocol {
    func create<Q>(query: Q) async throws -> Q.Value where Q: StructuredStorageQuery
    func read<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery
    func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws where Q: StructuredStorageQuery
    @discardableResult func delete<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery
}

public actor StructuredStorage: StructuredStorageProtocol {
    private let _persistentContainer: NSPersistentContainer

    init() {
        _persistentContainer = NSPersistentContainer(name: "DomainModel")
        _persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                // TODO: Log
                print(error)
            }
        }
    }

    public func create<Q>(query: Q) async throws -> Q.Value where Q: StructuredStorageQuery {
        let context = _persistentContainer.newBackgroundContext()
        return try await context.perform {
            let value = query.defaultValue(context: context)
            try context.saveIfNeeded()
            return value
        }
    }

    @MainActor
    public func read<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
        let context = _persistentContainer.viewContext
        return try context.fetch(query.request)
    }

    public func update<Q>(query: Q, perform: @escaping (inout Q.Value) -> Void) async throws
        where Q: StructuredStorageQuery {
        let context = _persistentContainer.newBackgroundContext()
        try await context.perform {
            let values = try context.fetch(query.request)
            for value in values {
                var newValue = value
                perform(&newValue)
            }

            try context.saveIfNeeded()
        }
    }

    @discardableResult public func delete<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
        let context = _persistentContainer.newBackgroundContext()
        return try await context.perform {
            let values = try context.fetch(query.request)
            for value in values {
                context.delete(value)
            }

            try context.saveIfNeeded()

            return values
        }
    }
}
