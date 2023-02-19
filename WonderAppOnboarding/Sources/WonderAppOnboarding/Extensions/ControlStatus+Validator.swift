//
//  File.swift
//
//
//  Created by Valentin Radu on 19/02/2023.
//

import WonderAppExtensions

extension ControlStatus {
    init(value: String, validator: (String) -> Error?) {
        if value.isEmpty {
            self = .idle
        } else if let error = validator(value) {
            self = .failure(message: error.localizedDescription)
        } else {
            self = .success()
        }
    }
}
