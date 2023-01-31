//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import Foundation

struct AttributedStringSample {
    let singleWord: AttributedString = .init("Lorem")
    let twoWords: AttributedString = .init("Lorem ipsum")
}

extension AttributedString {
    static let samples: AttributedStringSample = .init()
}
