//
//  CDDepositionPartner+CoreDataProperties.swift
//  deposition-points
//
//  Created by laGrunge on 10/1/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

extension CDDepositionPartner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDepositionPartner> {
        return NSFetchRequest<CDDepositionPartner>(entityName: "CDDepositionPartner")
    }

    @NSManaged public var uniqueId: String?
    @NSManaged public var name: String?
    @NSManaged public var picture: String?
}
