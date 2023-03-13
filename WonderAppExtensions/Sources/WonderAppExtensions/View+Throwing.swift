//
//  File.swift
//
//
//  Created by Valentin Radu on 11/02/2023.
//

import SwiftUI

private struct ErrorsEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<[AnyError]> = .constant([])
}

private extension EnvironmentValues {
    var errors: Binding<[AnyError]> {
        get { self[ErrorsEnvironmentKey.self] }
        set { self[ErrorsEnvironmentKey.self] = newValue }
    }
}

private struct HumanReadableErrorEnvironmentKey: EnvironmentKey {
    static var defaultValue: (Error) -> String? = { $0.localizedDescription }
}

private extension EnvironmentValues {
    var humanReadableError: (Error) -> String? {
        get { self[HumanReadableErrorEnvironmentKey.self] }
        set { self[HumanReadableErrorEnvironmentKey.self] = newValue }
    }
}

private struct HumanReadableErrorProviderModifier: ViewModifier {
    @Environment(\.humanReadableError) private var _parentProvider: (Error) -> String?

    private let _wrappedValue: (Error) -> String?

    init(_ wrappedValue: @escaping (Error) -> String?) {
        _wrappedValue = wrappedValue
    }

    func body(content: Content) -> some View {
        content
            .environment(\.humanReadableError) {
                _wrappedValue($0) ?? _parentProvider($0)
            }
    }
}

public extension View {
    func humanReadableError(_ provider: @escaping (Error) -> String?) -> some View {
        modifier(HumanReadableErrorProviderModifier(provider))
    }
}

@MainActor
public struct ErrorContext {
    static let constant: ErrorContext = .init(errors: .constant([]),
                                              humanReadableError: { $0.localizedDescription })
    @Binding private var _errors: [AnyError]
    private let _humanReadableError: (Error) -> String

    fileprivate init(errors: Binding<[AnyError]>,
                     humanReadableError: @escaping (Error) -> String?) {
        __errors = errors
        _humanReadableError = {
            humanReadableError($0) ?? $0.localizedDescription
        }
    }

    public func report<E>(error: E) where E: Error {
        _errors.append(error.asAnyError)
    }

    public func dismiss<E>(error: E) where E: Error {
        if let i = _errors.firstIndex(of: error.asAnyError) {
            _errors.remove(at: i)
        }
    }

    public func performThrowingAction(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            report(error: error)
        }
    }

    public func lookUp<E>(error: E.Type) -> [E] where E: Error {
        _errors.compactMap {
            $0.underlyingError as? E
        }
    }

    public var allErrors: [AnyError] {
        _errors
    }
}

public struct ErrorBoundary<C>: View where C: View {
    @State private var _errors: [AnyError] = []
    private let _content: C

    public init(@ViewBuilder _ contentBuilder: @escaping () -> C) {
        _content = contentBuilder()
    }

    public var body: some View {
        _content
            .environment(\.errors, $_errors)
    }
}

public struct ErrorContextReader<C>: View where C: View {
    @Environment(\.humanReadableError) private var _humanReadableError
    @Environment(\.errors) private var _errors
    private let _contentBuilder: (ErrorContext) -> C

    public init(@ViewBuilder _ contentBuilder: @escaping (ErrorContext) -> C) {
        _contentBuilder = contentBuilder
    }

    public var body: some View {
        let context = ErrorContext(errors: _errors,
                                   humanReadableError: _humanReadableError)
        _contentBuilder(context)
    }
}
