//
//  File.swift
//
//
//  Created by Valentin Radu on 02/03/2023.
//

import SwiftUI

private struct ToastModifier<M, C>: ViewModifier where M: Equatable, C: View {
    private let _builder: (M) -> C
    @Binding private var _message: M?

    init(_ message: Binding<M?>, @ViewBuilder builder: @escaping (M) -> C) {
        _builder = builder
        __message = message
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                if let message = _message {
                    ZStack(alignment: .bottom) {
                        _builder(message)
                            .frame(greedy: .horizontal, alignment: .leading)
                            .padding(.ds.s4)
                            .onTapGesture {
                                _message = nil
                            }
                    }
                    .frame(greedy: .all, alignment: .bottom)
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut, value: _message)
    }
}

private struct ShowToastEnvironmentKey: EnvironmentKey {
    static var defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {
    var showToast: (AnyHashable) -> Void {
        get { self[ShowToastEnvironmentKey.self] }
        set { self[ShowToastEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func toast<M, C>(_ message: Binding<M?>, @ViewBuilder builder: @escaping (M) -> C) -> some View
        where M: Equatable, C: View {
        modifier(ToastModifier(message, builder: builder))
    }
}

private struct ToastSample: View {
    @State private var _message: String?

    var body: some View {
        Color.ds.oceanBlue900
            .ignoresSafeArea()
            .toast($_message) { message in
                Text(verbatim: message)
                    .frame(greedy: .horizontal)
                    .padding(.ds.d1)
                    .background {
                        RoundedRectangle(cornerRadius: .ds.r1)
                            .fill(Color.ds.oceanBlue400)
                    }
                    .foregroundColor(.ds.white)
            }
            .onTapGesture {
                _message = _message.isNil ? .samples.paragraph : nil
            }
    }
}

struct ToastPreviews: PreviewProvider {
    static var previews: some View {
        ToastSample()
    }
}
