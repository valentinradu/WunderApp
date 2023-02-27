//
//  File.swift
//
//
//  Created by Valentin Radu on 11/02/2023.
//

import SwiftUI

private struct OnChangeTaskModifier<V>: ViewModifier where V: Equatable {
    let value: V
    let priority: TaskPriority
    let perform: (V) async throws -> Void
    @State private var _newValue: V?

    func body(content: Content) -> some View {
        content
            .onChange(of: value) { value in
                _newValue = value
            }
            .task(id: _newValue, priority: priority) {
                if let newValue = _newValue {
                    try await perform(newValue)
                }
            }
    }
}

private struct OnAppearTaskModifier: ViewModifier {
    @State private var _didAppear: Bool = false
    let priority: TaskPriority
    let perform: () async throws -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: _didAppear,
                      priority: priority,
                      perform: { _ in
                          try await perform()
                      })
            .onAppear {
                _didAppear = true
            }
    }
}

private struct ThrowingRepeatingTaskModifier<ID>: ViewModifier where ID: Equatable {
    let id: ID
    let priority: TaskPriority
    let action: () async throws -> Void
    @State private var _errors: [AnyError] = []

    func body(content: Content) -> some View {
        content
            .task(id: id, priority: priority) {
                do {
                    try await action()
                } catch {
                    _errors = [AnyError(error)]
                }
            }
            .preference(key: ErrorPreferenceKey.self,
                        value: _errors)
    }
}

private struct ThrowingTaskModifier: ViewModifier {
    let priority: TaskPriority
    let action: () async throws -> Void
    @State private var _errors: [AnyError] = []

    func body(content: Content) -> some View {
        content
            .task(priority: priority) {
                do {
                    try await action()
                } catch {
                    _errors = [AnyError(error)]
                }
            }
            .preference(key: ErrorPreferenceKey.self,
                        value: _errors)
    }
}

private struct OnSpecificErrorTaskModifier<E>: ViewModifier where E: Error, E: Hashable {
    let error: E
    let perform: (E) -> Void

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(ErrorPreferenceKey.self) { value in
                if value.compactMap({ $0.underlyingError as? E }).contains(error) {
                    perform(error)
                }
            }
    }
}

private struct OnMultipleErrorsTaskModifier<E>: ViewModifier where E: Error, E: Hashable {
    let errors: Set<E>
    let perform: (E) -> Void

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(ErrorPreferenceKey.self) { value in
                for error in value.compactMap({ $0.underlyingError as? E }) where errors.contains(error) {
                    perform(error)
                }
            }
    }
}

public extension View {
    func onChange<V>(of value: V,
                     priority: TaskPriority = .medium,
                     perform: @escaping (V) async throws -> Void) -> some View where V: Equatable {
        modifier(OnChangeTaskModifier(value: value,
                                      priority: priority,
                                      perform: perform))
    }

    func onAppear(priority: TaskPriority = .medium,
                  perform: @escaping () async throws -> Void) -> some View {
        modifier(OnAppearTaskModifier(priority: priority,
                                      perform: perform))
    }

    func onError<E>(_ error: E, perform: @escaping (E) -> Void) -> some View where E: Error, E: Hashable {
        modifier(OnSpecificErrorTaskModifier(error: error, perform: perform))
    }

    func onError<E>(_ errors: Set<E>, perform: @escaping (E) -> Void) -> some View where E: Error, E: Hashable {
        modifier(OnMultipleErrorsTaskModifier(errors: errors, perform: perform))
    }

    func task<ID>(id: ID, priority: TaskPriority = .medium, action: @escaping () async throws -> Void) -> some View
        where ID: Equatable {
        modifier(ThrowingRepeatingTaskModifier(id: id, priority: priority, action: action))
    }

    func task<ID>(priority: TaskPriority = .medium, action: @escaping () async throws -> Void) -> some View {
        modifier(ThrowingTaskModifier(priority: priority, action: action))
    }
}

private struct ErrorPreferenceKey: PreferenceKey {
    static var defaultValue: [AnyError] = []

    static func reduce(value: inout [AnyError], nextValue: () -> [AnyError]) {
        value += nextValue()
    }
}
