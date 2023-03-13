//
//  File.swift
//
//
//  Created by Valentin Radu on 13/03/2023.
//

import Foundation

public enum SampleError: Error {
    case sentence
}

public extension SampleError {
    var localizableString: String {
        switch self {
        case .sentence:
            return .samples.sentence
        }
    }
}
