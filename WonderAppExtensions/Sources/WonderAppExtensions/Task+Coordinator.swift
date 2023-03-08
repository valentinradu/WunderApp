//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import Foundation

public class TaskPlanner<N> where N: Hashable {
    private var _storage: [N: Task<Void, Error>]

    public init() {
        _storage = [:]
    }

    public func perform(_ name: N, action: @escaping () async throws -> Void) {
        _storage[name]?.cancel()
        let task = Task { [weak self] in
            do {
                try await action()
            } catch {
                self?._storage.removeValue(forKey: name)
                throw error
            }
            self?._storage.removeValue(forKey: name)
        }
        _storage[name] = task
    }

    public func cancel(_ name: N) {
        if let task = _storage[name] {
            task.cancel()
        }
    }

    deinit {
        for (_, task) in _storage {
            task.cancel()
        }
    }
}
