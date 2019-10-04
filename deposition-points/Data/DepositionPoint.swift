//
//  DepositionPoint.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

struct DepositionPoint: Codable {
    let partnerName: String
    let externalId: String
    let location: Location
}

extension DepositionPoint: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uniqueId == rhs.uniqueId
    }
}
