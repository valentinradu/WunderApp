//
//  File.swift
//
//
//  Created by Valentin Radu on 03/02/2023.
//

import SwiftUI

struct OnboardingTextSecureToggle: View {
    @Binding var isRevealed: Bool

    var body: some View {
        Group {
            if isRevealed {
                Image(systemSymbol: .eye)
            } else {
                Image(systemSymbol: .eyeSlash)
            }
        }
        .frame(width: .ds.d2, height: .ds.d2, alignment: .trailing)
        .onTapGesture {
            isRevealed.toggle()
        }
    }
}

struct OnboardingTextStatusIcon: View {
    let status: OnboardingFormFieldStatus
    var body: some View {
        Group {
            switch status {
            case .idle:
                EmptyView()
            case .loading:
                SpinnerView()
                    .frame(width: .ds.d1, height: .ds.d1)
            case .success:
                Image(systemSymbol: .checkmarkCircleFill)
                    .foregroundColor(.ds.oceanGreen600)
            case .failure:
                Image(systemSymbol: .exclamationmarkCircleFill)
            }
        }
        .frame(width: .ds.d2, height: .ds.d2, alignment: .trailing)
    }
}

struct OnboardingTextStatusLabel: View {
    let status: OnboardingFormFieldStatus
    var body: some View {
        Group {
            switch status {
            case .idle:
                EmptyView()
            case .loading:
                EmptyView()
            case let .success(message), let .failure(message):
                if let message {
                    Text(message)
                } else {
                    EmptyView()
                }
            }
        }
        .font(.ds.md)
        .minimumScaleFactor(0.8)
        .frame(height: .ds.d1, alignment: .leading)
    }
}

struct OnboardingSecureField<P>: View where P: View {
    private var _placeholder: P
    private var _secureText: Binding<String>
    private var _isRevealed: Bool

    init(secureText: Binding<String>,
         isRevealed: Bool,
         @ViewBuilder placeholderBuilder: () -> P) {
        _placeholder = placeholderBuilder()
        _secureText = secureText
        _isRevealed = isRevealed
    }

    var body: some View {
        Group {
            if _isRevealed {
                TextField("", text: _secureText)
            } else {
                SecureField("", text: _secureText)
            }
        }
        .frame(height: .ds.d1)
        .background(alignment: .leading) {
            _placeholder
                .opacity(_secureText.wrappedValue.isEmpty ? 1 : 0)
                .allowsHitTesting(false)
                .foregroundColor(.ds.oceanBlue400)
        }
    }
}

struct OnboardingTextField<P>: View where P: View {
    private var _placeholder: P
    private var _text: Binding<String>

    init(text: Binding<String>,
         @ViewBuilder placeholderBuilder: () -> P) {
        _placeholder = placeholderBuilder()
        _text = text
    }

    var body: some View {
        TextField("", text: _text)
            .frame(height: .ds.d1)
            .background(alignment: .leading) {
                _placeholder
                    .opacity(_text.wrappedValue.isEmpty ? 1 : 0)
                    .allowsHitTesting(false)
                    .foregroundColor(.ds.oceanBlue400)
            }
    }
}

enum OnboardingFormFieldStatus: Codable {
    case idle
    case loading
    case failure(message: String? = nil)
    case success(message: String? = nil)
}

struct OnboardingFormField<T, I, U>: View where I: View, U: View, T: View {
    private let _icon: I
    private let _underline: U
    private let _base: T
    @FocusState private var _focused

    init(@ViewBuilder wrapping baseBuilder: () -> T,
         @ViewBuilder icon iconBuilder: () -> I,
         @ViewBuilder underline underlineBuilder: () -> U) {
        _base = baseBuilder()
        _icon = iconBuilder()
        _underline = underlineBuilder()
    }

    var body: some View {
        _base
            .focused($_focused)
            .padding(.vertical, .ds.s3)
            .safeAreaInset(edge: .trailing, spacing: 0) {
                _icon.fixedSize()
            }
            .font(.ds.xl)
            .padding(.horizontal, .ds.s3)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        _focused ? Color.ds.white : Color.ds.oceanBlue200,
                        lineWidth: _focused ? .ds.b1 : .ds.dpt
                    )
            )
            .safeAreaInset(edge: .bottom, spacing: 0) {
                _underline
            }
            .animation(.easeInOut, value: _focused)
            .foregroundColor(.ds.white)
            .onTapGesture {
                _focused = true
            }
    }

    init(text: Binding<String>,
         status: OnboardingFormFieldStatus,
         placeholder: AttributedString? = nil)
        where T == OnboardingTextField<Text?>, I == OnboardingTextStatusIcon, U == OnboardingTextStatusLabel {
        _icon = OnboardingTextStatusIcon(status: status)
        _underline = OnboardingTextStatusLabel(status: status)
        _base = OnboardingTextField(text: text) {
            if let placeholder {
                Text(placeholder)
            }
        }
    }

    init(secureText: Binding<String>,
         isRevealed: Binding<Bool>,
         status: OnboardingFormFieldStatus,
         placeholder: AttributedString? = nil)
        where T == OnboardingSecureField<Text?>, I == OnboardingTextSecureToggle, U == OnboardingTextStatusLabel {
        _icon = OnboardingTextSecureToggle(isRevealed: isRevealed)
        _underline = OnboardingTextStatusLabel(status: status)
        _base = OnboardingSecureField(secureText: secureText,
                                      isRevealed: isRevealed.wrappedValue) {
            if let placeholder {
                Text(placeholder)
            }
        }
    }
}

struct OnboardingFormFieldSample: View {
    @State private var _userName: String = ""
    @State private var _password: String = ""
    @State private var _isRevealed: Bool = true

    var body: some View {
        ScrollView {
            VStack {
                OnboardingFormField(text: $_userName,
                                    status: .idle,
                                    placeholder: .samples.twoWords)
                OnboardingFormField(text: $_userName,
                                    status: .success(message: .samples.sentence),
                                    placeholder: .samples.twoWords)
                OnboardingFormField(text: $_userName,
                                    status: .failure(message: .samples.sentence),
                                    placeholder: .samples.twoWords)
                OnboardingFormField(text: $_userName,
                                    status: .loading,
                                    placeholder: .samples.twoWords)
                OnboardingFormField(secureText: $_password,
                                    isRevealed: $_isRevealed,
                                    status: .idle,
                                    placeholder: .samples.twoWords)
                OnboardingFormField(secureText: $_password,
                                    isRevealed: $_isRevealed,
                                    status: .success(message: .samples.sentence),
                                    placeholder: .samples.twoWords)
                OnboardingFormField(secureText: $_password,
                                    isRevealed: $_isRevealed,
                                    status: .failure(message: .samples.sentence),
                                    placeholder: .samples.twoWords)
                OnboardingFormField(secureText: $_password,
                                    isRevealed: $_isRevealed,
                                    status: .loading,
                                    placeholder: .samples.twoWords)
                Spacer()
            }
            .padding(.ds.s3)
        }
        .background(Color.ds.oceanBlue900.edgesIgnoringSafeArea(.all))
    }
}

struct OnboardingFormFieldPreviews: PreviewProvider {
    public static var previews: some View {
        OnboardingFormFieldSample()
    }
}
