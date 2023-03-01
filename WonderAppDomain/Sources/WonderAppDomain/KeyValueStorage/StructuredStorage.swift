//
//  File.swift
//
//
//  Created by Valentin Radu on 01/03/2023.
//

import CoreData
import Foundation

// public protocol StructuredStorageQuery: Hashable {
//    associatedtype Value: NSFetchRequestResult
//    var request: NSFetchRequest<Value> { get }
// }
//
// public protocol StructuredStorageProtocol {
//    func fetch<Q>(query: Q) async throws -> Q.Value? where Q: StructuredStorageQuery
//    func save<Value>(value: Value) async throws
//    @discardableResult func remove<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery
// }
//
// public actor StructuredStorage: StructuredStorageProtocol {
//    private let _persistentContainer: NSPersistentContainer
//
//    init() {
//        _persistentContainer = NSPersistentContainer(name: "Domain")
//        _persistentContainer.loadPersistentStores { description, error in
//            if let error = error {
//                // TODO: Log
//                print(error)
//            }
//        }
//    }
//
//    public func fetch<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
//        let result = try _persistentContainer.viewContext.fetch(query.request)
//        return result
//    }
//
//    public func save<Value>(value: Value) async throws {
//        fatalError()
//    }
//
//    public func remove<Q>(query: Q) async throws -> [Q.Value] where Q: StructuredStorageQuery {
//        fatalError()
//    }
// }
