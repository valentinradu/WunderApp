//
//  File.swift
//
//
//  Created by Valentin Radu on 13/03/2023.
//

import Foundation

public struct FormControlModel: Hashable {
    public var status: ControlStatus
    public var isDisabled: Bool

    public init(status: ControlStatus = .idle,
                isDisabled: Bool = false) {
        self.status = status
        self.isDisabled = isDisabled
    }
}
