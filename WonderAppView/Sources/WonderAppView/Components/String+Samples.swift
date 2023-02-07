//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import Foundation

struct AttributedStringSample {
    let singleWord: AttributedString = .init(.samples.singleWord)
    let twoWords: AttributedString = .init(.samples.twoWords)
    let sentence: AttributedString = .init(.samples.sentence)
    let paragraph: AttributedString = .init(.samples.paragraph)
}

extension AttributedString {
    static let samples: AttributedStringSample = .init()
}

struct StringSample {
    let singleWord: String = "Lorem"
    let twoWords: String = "Lorem ipsum"
    let sentence: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    let paragraph: String =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam quis sapien accumsan augue commodo mollis. Aliquam dapibus turpis non turpis vestibulum congue. Nulla facilisi. Phasellus vitae tellus et diam luctus efficitur. Suspendisse potenti. Praesent fringilla, ipsum fermentum accumsan consequat, est ante ultrices tortor, ut gravida leo lorem id tellus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas."
}

extension String {
    static let samples: StringSample = .init()
}
