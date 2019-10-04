//
//  CDImageResource+CoreDataProperties.swift
//  deposition-points
//
//  Created by laGrunge on 10/4/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import CoreData

extension CDImageResource {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDImageResource> {
        return NSFetchRequest<CDImageResource>(entityName: "CDImageResource")
    }

    @NSManaged public var uniqueId: String?
    @NSManaged public var localPath: String?
    @NSManaged public var lastModified: String?
}
