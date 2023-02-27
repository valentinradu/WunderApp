//
//  File.swift
//
//
//  Created by Valentin Radu on 26/02/2023.
//

import SwiftUI

private struct FocusedBinaryBindingModifier: ViewModifier {
    @FocusState private var _focus: Bool
    @Binding private var _externalFocus: Bool

    init(_ binding: Binding<Bool>) {
        __externalFocus = binding
    }

    func body(content: Content) -> some View {
        content
            .focused($_focus)
            .onAppear {
                _focus = _externalFocus
            }
            .onChange(of: _focus) { focus in
                _externalFocus = focus
            }
            .onChange(of: _externalFocus) { focus in
                _focus = focus
            }
    }
}

private struct FocusedEqualsBindingModifier<V>: ViewModifier where V: Hashable {
    @FocusState private var _focus: V?
    @Binding private var _externalFocus: V?
    @Environment(\.isPresented) private var _isPresented
    private let _value: V?

    init(_ binding: Binding<V?>, equals value: V?) {
        __externalFocus = binding
        _value = value
    }

    func body(content: Content) -> some View {
        content
            .focused($_focus, equals: _value)
            .onAppear {
                _focus = _externalFocus
            }
            .onChange(of: _focus) { focus in
                if _isPresented {
                    _externalFocus = focus
                }
            }
            .onChange(of: _externalFocus) { focus in
                if _isPresented {
                    _focus = focus
                }
            }
    }
}

public extension View {
    func focused(_ binding: Binding<Bool>) -> some View {
        modifier(FocusedBinaryBindingModifier(binding))
    }

    func focused<V>(_ binding: Binding<V?>, equals value: V?) -> some View where V: Hashable {
        modifier(FocusedEqualsBindingModifier(binding, equals: value))
    }
}
