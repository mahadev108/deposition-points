//
//  CoreDataRepresentable.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataRepresentable {
    associatedtype ManagedObjectType: Persistable
    var uniqueId: String { get }
    func update(entity: ManagedObjectType)
}

extension CoreDataRepresentable {
    func sync(in context: NSManagedObjectContext) {
        let request = NSFetchRequest<ManagedObjectType>(entityName: ManagedObjectType.entityName)
        request.predicate = NSPredicate(format: "uniqueId == %@", uniqueId)
        guard let managedObject = try? context.fetch(request).first ?? NSEntityDescription.insertNewObject(forEntityName: ManagedObjectType.entityName, into: context) as? ManagedObjectType
         else {
            fatalError()
        }
        update(entity: managedObject)
    }
}
