//
//  WonderAppApp.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import os
import SwiftUI
import WonderAppDomain
import WonderAppExtensions
import WonderAppOnboarding

@main
struct WonderApp: App {
    var body: some Scene {
        WindowGroup {
            WonderAppContainer()
        }
    }
}

struct WonderAppContainer: View {
    #if TESTING
        @Service(\.mocking) private var _mockingService
    #endif

    @State private var _path: NavigationPath = .init()
    @State private var _presentedError: AnyError?
    private let _logger = Logger(subsystem: "com.wonderapp.demo",
                                 category: "ui")

    var body: some View {
        let navigationContext = NavigationContext(path: $_path)
        ZStack {
            ErrorBoundary {
                ErrorContextReader { errorContext in
                    AsyncBoundary {
                        NavigationStack(path: $_path) {
                            OnboardingView()
                                .task {
                                    #if TESTING
                                        do {
                                            try await _mockingService.awaitMocks()
                                        } catch {
                                            assertionFailure(error.localizedDescription)
                                        }
                                    #endif
                                }
                        }
                    }
                    .onChange(of: errorContext.allErrors) {
                        _presentedError = $0.last
                    }
                    .onChange(of: _presentedError) { _ in
                        if let presentedError = _presentedError {
                            errorContext.dismiss(error: presentedError)
                        }
                    }
                    .toast($_presentedError) { error in
                        HStack {
                            Text(verbatim: error.localizedDescription).layoutPriority(1)
                            Spacer()
                            Image(systemSymbol: .xmark)
                        }
                        .bold()
                        .frame(greedy: .horizontal, alignment: .leading)
                        .padding(.ds.d1)
                        .background(Color.ds.infraRed600)
                        .cornerRadius(.ds.r1)
                        .foregroundColor(.ds.white)
                    }
                }
            }
        }
        .frame(greedy: .all)
        .background(Color.ds.oceanBlue900)
        .environment(\.navigationContext, navigationContext)
        .environment(\.logger, _logger)
        .humanReadableError { error in
            if let error = error as? ServiceError {
                return error.localizedDescription
            } else {
                return .l10n.errorGeneric
            }
        }
    }
}
