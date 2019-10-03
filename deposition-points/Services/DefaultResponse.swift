//
//  DefaultResponse.swift
//  deposition-points
//
//  Created by laGrunge on 10/1/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

struct DefaultResponse<T: Decodable>: Decodable {
    let payload: [T]
}
