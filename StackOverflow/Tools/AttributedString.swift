//
//  AttributedString.swift
//  StackItUp
//
//  Created by mcs on 3/26/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

class AttributedString: Codable {
    let attributedString: NSAttributedString

    init(nsAttributedString: NSAttributedString) {
        self.attributedString = nsAttributedString
    }

    public required init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        guard let attributedString = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(singleContainer.decode(Data.self)) as? NSAttributedString else {
            throw DecodingError.dataCorruptedError(in: singleContainer, debugDescription: "Data is corrupted")
        }
        self.attributedString = attributedString
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false))
    }
}
