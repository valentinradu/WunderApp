//
//  File.swift
//
//
//  Created by Valentin Radu on 13/03/2023.
//

import Foundation

public struct FormFieldModel: Hashable {
    public static func == (lhs: FormFieldModel, rhs: FormFieldModel) -> Bool {
        lhs.value == rhs.value &&
            lhs.status == rhs.status &&
            lhs.isRedacted == rhs.isRedacted
    }

    public var value: String {
        didSet {
            validateContinuously()
        }
    }

    public var status: ControlStatus
    public var isRedacted: Bool
    public var validator: (String) -> InputValidatorError?

    public init(
        value: String = "",
        status: ControlStatus = .idle,
        isRedacted: Bool = false,
        validator: @escaping (String) -> InputValidatorError? = { _ in nil }
    ) {
        self.value = value
        self.status = status
        self.isRedacted = isRedacted
        self.validator = validator
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(status)
        hasher.combine(isRedacted)
    }

    public mutating func validate() {
        guard !value.isEmpty else { return }
        if let error = validator(value) {
            status = .failure(error.asAnyError)
        } else {
            status = .success
        }
    }

    private mutating func validateContinuously() {
        let error = validator(value)
        if let error {
            if status != .idle {
                status = .failure(error.asAnyError)
            }
        } else {
            status = .success
        }
    }
}
