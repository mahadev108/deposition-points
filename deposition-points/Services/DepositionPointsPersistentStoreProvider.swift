//
//  DepositionPointsPersistentStoreProvider.swift
//  deposition-points
//
//  Created by laGrunge on 9/30/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

protocol DepositionPersistentStoreProviderType {
    func depositionPoints(with: DepositionPointsSearchParams, completion: @escaping DepositionPointsCompletion)
    func depositionPartner(name: String, completion: (DepositionPartner?) -> Void)
}

final class DepositionPersistentStoreProvider: DepositionPersistentStoreProviderType {
    let pointsRepository: Repository<DepositionPoint>
    let partnersRepository: Repository<DepositionPartner>
    
    init(context: NSManagedObjectContext) {
        self.pointsRepository = Repository(context: context)
        self.partnersRepository = Repository(context: context)
    }
    
    func depositionPoints(with params: DepositionPointsSearchParams, completion: @escaping DepositionPointsCompletion) {
        let predicate = NSPredicate(format: "(%@ <= longitude) AND (longitude <= %@) AND (%@ <= latitude) AND (latitude <= %@)", NSNumber(value: params.minLongitude), NSNumber(value: params.maxLongitude), NSNumber(value: params.minLatitude), NSNumber(value: params.maxLatitude))
        do {
            let results = try pointsRepository.query(with: predicate)
            completion(.success(results))
        } catch {
            completion(.failure(error))
        }
    }
    
    func depositionPartner(name: String, completion: (DepositionPartner?) -> Void) {
        let predicate = NSPredicate(format: "uniqueId == %@", name)
        let result = try? partnersRepository.query(with: predicate).first
        completion(result)
    }
}
