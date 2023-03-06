//
//  WonderAppUITests.swift
//  WonderAppUITests
//
//  Created by Valentin Radu on 04/03/2023.
//

import WonderAppExtensions
import XCTest

final class WonderAppUITests: XCTestCase {
    override func setUp() async throws {
        continueAfterFailure = false
    }

    override func tearDown() async throws {
        //
    }

    @MainActor
    func testExample() async throws {
        let clamant = try PeerClamant<MockPeerMessage>(name: "my-first-test", password: "pass")

        let app = XCUIApplication()
        app.launch()

        await clamant.listen()
        let connection = try await clamant.waitForConnection()

        let data = "Hello".data(using: .utf8)!
        connection.send(kind: .test, data: data)

        try await Task.sleep(for: .seconds(30))
    }
}
