//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

struct OnboardingButtonStyle: PrimitiveButtonStyle {
    @Environment(\.isEnabled) private var _isEnabled
    @Environment(\.isLoading) private var _isLoading
    @State private var _isPressed = false

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if configuration.role == .cancel {
                Group {
                    if _isLoading {
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
                .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.ds.white, lineWidth: .ds.b1)
                )
                .opacity(_isPressed || !_isEnabled && !_isLoading ? 0.6 : 1)
            } else {
                Group {
                    if _isLoading {
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
                .background(
                    _isEnabled || _isLoading ?
                        Color.ds.oceanGreen600 :
                        Color.ds.oceanGreen100.opacity(0.6)
                )
                .cornerRadius(.infinity)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !_isLoading, _isEnabled {
                        _isPressed = true
                    }
                }
                .onEnded { gesture in
                    _isPressed = false
                    if !_isLoading, _isEnabled {
                        configuration.trigger()
                    }
                }
        )
    }
}

struct WelcomeButtonSample: View {
    var body: some View {
        VStack(spacing: .ds.s4) {
            _sampleButton()
            _sampleButton(withRole: .cancel)
            _sampleButton()
                .disabled(true)
            _sampleButton(withRole: .cancel)
                .disabled(true)
            _sampleButton()
                .environment(\.isLoading, true)
            _sampleButton(withRole: .cancel)
                .environment(\.isLoading, true)
        }
        .padding(.ds.s4)
        .frame(greedy: .all)
        .background(Color.ds.oceanBlue900)
        .buttonStyle(OnboardingButtonStyle())
    }

    @ViewBuilder
    private func _sampleButton(withRole role: ButtonRole? = nil) -> some View {
        Button(
            role: role,
            action: {},
            label: {
                Text(.samples.singleWord)
            }
        )
    }
}

struct WelcomeButtonPreviews: PreviewProvider {
    public static var previews: some View {
        WelcomeButtonSample()
    }
}
