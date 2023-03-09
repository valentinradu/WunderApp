//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import SwiftUI

public typealias Dispatch = (AnyHashable, @escaping () async throws -> Void) -> Void

private struct DispatchEnvironmentKey: EnvironmentKey {
    static var defaultValue: Dispatch = { _, _ in }
}

public extension EnvironmentValues {
    var dispatch: Dispatch {
        get { self[DispatchEnvironmentKey.self] }
        set { self[DispatchEnvironmentKey.self] = newValue }
    }
}

public class TaskPlanner<N>: ObservableObject where N: Hashable {
    private var _storage: [N: Task<Void, Never>]
    @Published public private(set) var error: Error?

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
                self?.error = error
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
