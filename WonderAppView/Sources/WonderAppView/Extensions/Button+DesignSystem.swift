//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import SwiftUI

struct WelcomeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if configuration.role == .cancel {
            configuration.label
                .labelStyle(.titleOnly)
                .font(.ds.xl)
                .foregroundColor(.ds.white)
                .padding(.ds.s3)
                .frame(greedy: .horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.ds.white, lineWidth: .ds.b1)
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
        } else {
            configuration.label
                .labelStyle(.titleOnly)
                .opacity(configuration.isPressed ? 0.5 : 1)
                .font(.ds.xl)
                .foregroundColor(.ds.oceanGreen900)
                .padding(.ds.s3)
                .frame(greedy: .horizontal)
                .background(Color.ds.oceanGreen600)
                .cornerRadius(.infinity)
        }
    }
}

struct WelcomeButtonPreviews: PreviewProvider {
    public static var previews: some View {
        VStack(spacing: .ds.s4) {
            Button(
                action: {},
                label: {
                    Text(.samples.singleWord)
                }
            )
            Button(
                role: .cancel,
                action: {},
                label: {
                    Text(.samples.singleWord)
                }
            )
        }
        .padding(.ds.s4)
        .frame(greedy: .both)
        .background(Color.ds.oceanBlue900)
        .buttonStyle(WelcomeButtonStyle())
    }
}
