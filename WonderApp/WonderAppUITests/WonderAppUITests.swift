//
//  WonderAppUITests.swift
//  WonderAppUITests
//
//  Created by Valentin Radu on 04/03/2023.
//

import PeerTunnel
import WonderAppDomain
import WonderAppExtensions
import XCTest

final class WonderAppUITests: XCTestCase {
    @Service(\.mocking) private var _mockingService

    override func setUp() async throws {
        continueAfterFailure = false
        try await _mockingService.prepare()
    }

    override func tearDown() async throws {
        //
    }

    @MainActor
    func testExample() async throws {
        let app = XCUIApplication()
        app.launch()

        let accountService = AccountServiceMock()

        try await _mockingService.mock(service: .accountService, value: accountService)

        try await Task.sleep(for: .seconds(30))
    }
}
