//
//  File.swift
//
//
//  Created by Valentin Radu on 03/02/2023.
//

import SwiftUI

extension Onboarding {
    struct FormFieldSecureToggle: View {
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

    struct FormFieldStatusIcon: View {
        let status: FormFieldStatus
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

    struct FormFieldStatusBorder: View {
        @FocusState private var _focused
        let status: FormFieldStatus

        var body: some View {
            RoundedRectangle(cornerRadius: 5)
                .stroke(_color, lineWidth: _lineWidth)
        }

        private var _color: Color {
            switch status {
            case .failure:
                return .ds.infraRed600
            default:
                return _focused ? Color.ds.white : Color.ds.oceanBlue200
            }
        }

        private var _lineWidth: CGFloat {
            switch status {
            case .failure:
                return .ds.b1
            default:
                return _focused ? .ds.b1 : .ds.bpt
            }
        }
    }

    struct FormFieldStatusLabel: View {
        let status: FormFieldStatus
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

    struct SecureFieldView<P>: View where P: View {
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
            ZStack {
                SwiftUI.TextField("", text: _secureText)
                    .opacity(_isRevealed ? 1 : 0)
                SwiftUI.SecureField("", text: _secureText)
                    .opacity(_isRevealed ? 0 : 1)
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

    struct TextFieldView<P>: View where P: View {
        private var _placeholder: P
        private var _text: Binding<String>

        init(text: Binding<String>,
             @ViewBuilder placeholderBuilder: () -> P) {
            _placeholder = placeholderBuilder()
            _text = text
        }

        var body: some View {
            SwiftUI.TextField("", text: _text)
                .frame(height: .ds.d1)
                .background(alignment: .leading) {
                    _placeholder
                        .opacity(_text.wrappedValue.isEmpty ? 1 : 0)
                        .allowsHitTesting(false)
                        .foregroundColor(.ds.oceanBlue400)
                }
        }
    }

    struct FormFieldView<T, I, U, O>: View where I: View, U: View, T: View, O: View {
        private let _icon: I
        private let _underline: U
        private let _overlay: O
        private let _base: T
        @FocusState private var _focused

        init(@ViewBuilder wrapping baseBuilder: () -> T,
             @ViewBuilder icon iconBuilder: () -> I,
             @ViewBuilder underline underlineBuilder: () -> U,
             @ViewBuilder overlay overlayBuilder: () -> O) {
            _base = baseBuilder()
            _icon = iconBuilder()
            _underline = underlineBuilder()
            _overlay = overlayBuilder()
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
                .overlay(_overlay)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    _underline
                        .frame(greedy: .horizontal, alignment: .leading)
                }
                .animation(.easeInOut, value: _focused)
                .foregroundColor(.ds.white)
                .frame(maxWidth: .ds.d9)
                .onTapGesture {
                    _focused = true
                }
        }

        init(text: Binding<String>,
             status: FormFieldStatus,
             placeholder: AttributedString? = nil)
            where T == TextFieldView<Text?>, I == FormFieldStatusIcon,
            U == FormFieldStatusLabel,
            O == FormFieldStatusBorder {
            _icon = FormFieldStatusIcon(status: status)
            _underline = FormFieldStatusLabel(status: status)
            _base = TextFieldView(text: text) {
                if let placeholder {
                    Text(placeholder)
                }
            }
            _overlay = FormFieldStatusBorder(status: status)
        }

        init(secureText: Binding<String>,
             isRevealed: Binding<Bool>,
             status: FormFieldStatus,
             placeholder: AttributedString? = nil)
            where T == SecureFieldView<Text?>, I == FormFieldSecureToggle,
            U == FormFieldStatusLabel, O == FormFieldStatusBorder {
            _icon = FormFieldSecureToggle(isRevealed: isRevealed)
            _underline = FormFieldStatusLabel(status: status)
            _base = SecureFieldView(secureText: secureText,
                                    isRevealed: isRevealed.wrappedValue) {
                if let placeholder {
                    Text(placeholder)
                }
            }
            _overlay = FormFieldStatusBorder(status: status)
        }
    }

    private struct FormFieldViewSample: View {
        @State private var _userName: String = ""
        @State private var _password: String = ""
        @State private var _isRevealed: Bool = true

        var body: some View {
            ScrollView {
                VStack {
                    FormFieldView(text: $_userName,
                                  status: .idle,
                                  placeholder: .samples.twoWords)
                    FormFieldView(text: $_userName,
                                  status: .success(message: .samples.sentence),
                                  placeholder: .samples.twoWords)
                    FormFieldView(text: $_userName,
                                  status: .failure(message: .samples.sentence),
                                  placeholder: .samples.twoWords)
                    FormFieldView(text: $_userName,
                                  status: .loading,
                                  placeholder: .samples.twoWords)
                    FormFieldView(secureText: $_password,
                                  isRevealed: $_isRevealed,
                                  status: .idle,
                                  placeholder: .samples.twoWords)
                    FormFieldView(secureText: $_password,
                                  isRevealed: $_isRevealed,
                                  status: .success(message: .samples.sentence),
                                  placeholder: .samples.twoWords)
                    FormFieldView(secureText: $_password,
                                  isRevealed: $_isRevealed,
                                  status: .failure(message: .samples.sentence),
                                  placeholder: .samples.twoWords)
                    FormFieldView(secureText: $_password,
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

    struct FormFieldPreviews: PreviewProvider {
        static var previews: some View {
            FormFieldViewSample()
        }
    }
}
