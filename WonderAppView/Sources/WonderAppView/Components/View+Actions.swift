//
//  File.swift
//
//
//  Created by Valentin Radu on 08/02/2023.
//

import SwiftUI

typealias Dispatch<A> = (A) -> Void

private struct DispatchEnvironmentKey: EnvironmentKey {
    static var defaultValue: Dispatch<any Hashable> = { _ in }
}

extension EnvironmentValues {
    var dispatch: Dispatch<any Hashable> {
        get { self[DispatchEnvironmentKey.self] }
        set { self[DispatchEnvironmentKey.self] = newValue }
    }
}

private struct ActionHandlerModifier<A>: ViewModifier {
    @Environment(\.dispatch) private var _dispatch
    private let _type: A.Type
    private let _handler: Dispatch<A>

    init(for type: A.Type, handler: @escaping Dispatch<A>) {
        _type = type
        _handler = handler
    }

    func body(content: Content) -> some View {
        content
            .environment(\.dispatch) { action in
                if let action = action as? A {
                    _handler(action)
                } else {
                    _dispatch(action)
                }
            }
    }
}

extension View {
    func handle<A>(actions type: A.Type,
                   with handler: @escaping Dispatch<A>) -> some View {
        modifier(ActionHandlerModifier(for: type, handler: handler))
    }
}
