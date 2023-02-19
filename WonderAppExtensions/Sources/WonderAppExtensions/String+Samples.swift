//
//  File.swift
//
//
//  Created by Valentin Radu on 30/01/2023.
//

import Foundation

public struct AttributedStringSample {
    public let singleWord: AttributedString = .init(.samples.singleWord)
    public let twoWords: AttributedString = .init(.samples.twoWords)
    public let sentence: AttributedString = .init(.samples.sentence)
    public let paragraph: AttributedString = .init(.samples.paragraph)
}

public extension AttributedString {
    static let samples: AttributedStringSample = .init()
}

public struct StringSample {
    public let singleWord: String = "Lorem"
    public let twoWords: String = "Lorem ipsum"
    public let sentence: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    public let paragraph: String =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam quis sapien accumsan augue commodo mollis. Aliquam dapibus turpis non turpis vestibulum congue. Nulla facilisi. Phasellus vitae tellus et diam luctus efficitur. Suspendisse potenti. Praesent fringilla, ipsum fermentum accumsan consequat, est ante ultrices tortor, ut gravida leo lorem id tellus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas."
}

public extension String {
    static let samples: StringSample = .init()
}
