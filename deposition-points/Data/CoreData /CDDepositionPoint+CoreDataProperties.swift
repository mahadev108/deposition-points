//
//  CDDepositionPoint+CoreDataProperties.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import CoreData

extension CDDepositionPoint {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDepositionPoint> {
        let request = NSFetchRequest<CDDepositionPoint>(entityName: "CDDepositionPoint")
        request.fetchLimit = 1000
        return request
    }

    @NSManaged public var partnerName: String?
    @NSManaged public var externalId: String?
    @NSManaged public var uniqueId: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}
