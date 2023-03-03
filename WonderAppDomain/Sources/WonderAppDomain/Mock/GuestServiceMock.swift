//
//  File.swift
//
//
//  Created by Valentin Radu on 03/03/2023.
//

import Foundation
import WonderAppExtensions

public class GuestServiceMock: Codable, GuestServiceProtocol {
    public var isEmailAvailableResult: MockedResult<Bool, ServiceError> = .success(value: true)

    public func isEmailAvailable(_ value: String) async throws -> Bool {
        try await isEmailAvailableResult.unwrap()
    }
}
