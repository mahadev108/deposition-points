//
//  Repository.swift
//  deposition-points
//
//  Created by laGrunge on 9/30/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

protocol RepositoryType {
    associatedtype T
    func query(with predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]?) throws -> [T]
}

final class Repository<T: CoreDataRepresentable>: RepositoryType where T == T.ManagedObjectType.StructType {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func query(with predicate: NSPredicate? = nil,
               sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let request = T.ManagedObjectType.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return try context.fetch(request).map { $0.asStruct() }
    }
}
