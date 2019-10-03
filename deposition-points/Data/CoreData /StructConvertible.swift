//
//  StructConvertible.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

protocol StructConvertible {
    associatedtype StructType
    func asStruct() -> StructType
}
