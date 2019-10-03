//
//  Persistable.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

protocol Persistable: NSFetchRequestResult, StructConvertible {
    static var entityName: String { get }
    static func fetchRequest() -> NSFetchRequest<Self>
}
