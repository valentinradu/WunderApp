//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI
import WonderAppExtensions

public struct FormButtonStyle: PrimitiveButtonStyle {
    @Environment(\.isEnabled) private var _isEnabled
    @Environment(\.controlStatus) private var _controlStatus
    @State private var _isPressed = false

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        Group {
            if configuration.role == .cancel {
                _makeCancelFormButton(configuration: configuration)
            } else {
                _makeRegularFormButton(configuration: configuration)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if _controlStatus != .loading, _isEnabled {
                        _isPressed = true
                    }
                }
                .onEnded { gesture in
                    _isPressed = false
                    if _controlStatus != .loading, _isEnabled {
                        configuration.trigger()
                    }
                }
        )
    }

    @ViewBuilder
    private func _makeCancelFormButton(configuration: Configuration) -> some View {
        let isLoading = _controlStatus == .loading
        Group {
            if isLoading {
                SpinnerView()
                    .frame(width: .ds.d1, height: .ds.d1)
            } else {
                configuration.label
            }
        }
        .labelStyle(.titleOnly)
        .font(.ds.xl)
        .bold(true)
        .foregroundColor(.ds.white)
        .padding(.ds.s3)
        .frame(greedy: .horizontal)
        .frame(maxWidth: .ds.d7)
        .overlay(
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(Color.ds.white, lineWidth: .ds.b1)
        )
        .opacity(_isPressed || !_isEnabled && !isLoading ? 0.6 : 1)
    }

    @ViewBuilder
    private func _makeRegularFormButton(configuration: Configuration) -> some View {
        let isLoading = _controlStatus == .loading
        Group {
            if isLoading {
                SpinnerView()
                    .frame(width: .ds.d1, height: .ds.d1)
            } else {
                configuration.label
            }
        }
        .labelStyle(.titleOnly)
        .opacity(_isPressed ? 0.5 : 1)
        .font(.ds.xl)
        .bold(true)
        .foregroundColor(.ds.oceanGreen900)
        .padding(.ds.s3)
        .frame(greedy: .horizontal)
        .frame(maxWidth: .ds.d7)
        .background(
            _isEnabled || isLoading ?
                Color.ds.oceanGreen600 :
                Color.ds.oceanGreen100.opacity(0.6)
        )
        .cornerRadius(.infinity)
    }
}

struct FormButtonSample: View {
    let _role: ButtonRole?

    init(role: ButtonRole? = nil) {
        _role = role
    }

    var body: some View {
        Button(
            role: _role,
            action: {},
            label: {
                Text(.samples.singleWord)
            }
        )
    }
}

struct FormButtonPreviews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .ds.s4) {
            FormButtonSample()
            FormButtonSample(role: .cancel)
            FormButtonSample()
                .disabled(true)
            FormButtonSample(role: .cancel)
                .disabled(true)
            FormButtonSample()
                .environment(\.controlStatus, .loading)
            FormButtonSample(role: .cancel)
                .environment(\.controlStatus, .loading)
        }
        .padding(.ds.s4)
        .frame(greedy: .all)
        .background(Color.ds.oceanBlue900)
        .buttonStyle(FormButtonStyle())
    }
}
