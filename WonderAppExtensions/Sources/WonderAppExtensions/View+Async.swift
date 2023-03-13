//
//  File.swift
//
//
//  Created by Valentin Radu on 10/03/2023.
//

import SwiftUI

private struct AsyncTasksEnvironmentKey: EnvironmentKey {
    static var defaultValue: ReferenceBox<[AnyHashable: Task<Void, Never>]> = .init([:])
}

private extension EnvironmentValues {
    var asyncTasks: ReferenceBox<[AnyHashable: Task<Void, Never>]> {
        get { self[AsyncTasksEnvironmentKey.self] }
        set { self[AsyncTasksEnvironmentKey.self] = newValue }
    }
}

@MainActor
public final class AsyncContext {
    private var _asyncTasks: ReferenceBox<[AnyHashable: Task<Void, Never>]>
    private let _errorContext: ErrorContext

    static let constant: AsyncContext = .init(asyncTasks: .init([:]), errorContext: .constant)

    fileprivate init(asyncTasks: ReferenceBox<[AnyHashable: Task<Void, Never>]>,
                     errorContext: ErrorContext) {
        _errorContext = errorContext
        _asyncTasks = asyncTasks
    }

    public func performTask(named name: AnyHashable,
                            debounce: TimeInterval? = nil,
                            action: @escaping () async throws -> Void) {
        _asyncTasks.value[name]?.cancel()
        _asyncTasks.value[name] = Task.detached { [weak self] in
            if let debounce = debounce {
                do {
                    try await Task.sleep(for: .seconds(debounce))
                    try Task.checkCancellation()
                } catch {
                    return
                }
            }

            do {
                try await action()
            } catch {
                await self?.removeTask(named: name)
                await self?._errorContext.report(error: error)
            }
            await self?.removeTask(named: name)
        }
    }

    public func cancelTask(named name: AnyHashable) {
        if let task = _asyncTasks.value[name] {
            task.cancel()
        }
    }

    private func removeTask(named name: AnyHashable) {
        _asyncTasks.value.removeValue(forKey: name)
    }

    deinit {
        for (_, task) in _asyncTasks.value {
            task.cancel()
        }
    }
}

public struct AsyncBoundary<C>: View where C: View {
    private let _content: C
    @State private var _asyncTasks: ReferenceBox<[AnyHashable: Task<Void, Never>]> = .init([:])

    public init(@ViewBuilder _ contentBuilder: () -> C) {
        _content = contentBuilder()
    }

    public var body: some View {
        _content
            .environment(\.asyncTasks, _asyncTasks)
    }
}

public struct AsyncContextReader<C>: View where C: View {
    @Environment(\.asyncTasks) private var _asyncTasks
    private let _contentBuilder: (AsyncContext) -> C

    public init(@ViewBuilder _ contentBuilder: @escaping (AsyncContext) -> C) {
        _contentBuilder = contentBuilder
    }

    public var body: some View {
        ErrorContextReader { errorContext in
            let context = AsyncContext(asyncTasks: _asyncTasks, errorContext: errorContext)
            _contentBuilder(context)
        }
    }
}
