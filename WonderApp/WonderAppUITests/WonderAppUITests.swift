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
        let listener = try PeerListener(name: "my-first-test")

        let app = XCUIApplication()
        app.launch()

        try listener.listen()
        let connection = try await listener.waitForConnection()
        try await connection.send(value: "Helloo")

        try await Task.sleep(for: .seconds(30))
    }
}
