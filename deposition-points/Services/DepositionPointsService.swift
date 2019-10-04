//
//  DepositionPointsService.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

typealias DepositionPointsCompletion = (Result<[DepositionPoint], Error>) -> Void
typealias DepositionPartnersCompletion = (Result<[DepositionPartner], Error>) -> Void

struct DepositionPointsSearchParams: Equatable {
    let center: Location
    let radius: Double
    let maxLatitude: Double
    let maxLongitude: Double
    let minLatitude: Double
    let minLongitude: Double
}

protocol DepositionPointsServiceListener: class {
    func depositionPoints(_: [DepositionPoint])
}

protocol DepositionPointsServiceType {
    var listener: DepositionPointsServiceListener? { get set }
    func setSearchParams(_ : DepositionPointsSearchParams)
    func partnerImage(for: DepositionPoint, completion: @escaping (Data?) -> Void)
}

final class DepositionPointsService: DepositionPointsServiceType {
    
    weak var listener: DepositionPointsServiceListener?
    
    private let persistentContainer: NSPersistentContainer
    private let depositionPointsNetworkProvider: DepositionPointsNetworkProviderType
    private let depositionPartnersNetworkProvider: DepositionPartnersNetworkProviderType
    private let persistentStoreProvider: DepositionPersistentStoreProviderType
    private let imageService: ImageServiceType
    
    private var lastSearchParams: DepositionPointsSearchParams?
    
    init(depositionPointsNetworkProvider: DepositionPointsNetworkProviderType, depositionPartnersNetworkProvider: DepositionPartnersNetworkProviderType, imageService: ImageServiceType, persistentContainer: NSPersistentContainer) {
        self.depositionPointsNetworkProvider = depositionPointsNetworkProvider
        self.depositionPartnersNetworkProvider = depositionPartnersNetworkProvider
        self.imageService = imageService
        self.persistentContainer = persistentContainer
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentStoreProvider = DepositionPersistentStoreProvider(context: persistentContainer.viewContext)
    }
    
    func setSearchParams(_ params: DepositionPointsSearchParams) {
        
        lastSearchParams = params
        fetchPersistentStore(with: params)
       
        depositionPointsNetworkProvider.depositionPoints(with: params, completion: {
            [unowned self] result in
            switch result {
            case .success(let items):
                // Backgroud thread
                let taskContext = self.persistentContainer.newBackgroundContext()
                taskContext.performAndWait {
                    items.forEach { $0.sync(in: taskContext) }
                    if taskContext.hasChanges {
                        _ = try? taskContext.save()
                    }
                    taskContext.reset()
                }

                if let lastParams = self.lastSearchParams, params == lastParams {
                    self.fetchPersistentStore(with: params)
                }
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        })
        
    }
    
    func partnerImage(for point: DepositionPoint, completion: @escaping (Data?) -> Void) {
        persistentStoreProvider.depositionPartner(name: point.partnerName) { [unowned self] (partner) in
            if let partner = partner {
                self.imageData(path: partner.picture, completion: completion)
                return
            }
            // if partner is not found in persistent store load partners from the server
            self.depositionPartnersNetworkProvider.depositionPartners { result in
                switch result {
                case .success(let partners):
                    let partner = partners.filter { $0.id == point.partnerName }.first
                    if let partner = partner {
                        self.imageData(path: partner.picture, completion: completion)
                    }
                    // Backgroud thread
                     let taskContext = self.persistentContainer.newBackgroundContext()
                     taskContext.performAndWait {
                         partners.forEach { $0.sync(in: taskContext) }
                         if taskContext.hasChanges {
                             _ = try? taskContext.save()
                         }
                         taskContext.reset()
                     }
                case .failure(let error):
                    NSLog(error.localizedDescription)
                }
            }
        }
    }
    
    private func imageData(path: String, completion: @escaping (Data?) -> Void) {
        self.imageService.imageData(path: path) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func fetchPersistentStore(with params: DepositionPointsSearchParams) {
        DispatchQueue.main.async {
            self.persistentStoreProvider.depositionPoints(with: params) { [unowned self] result in
                switch result {
                case .success(let points):
                    self.listener?.depositionPoints(points)
                case .failure(let error):
                    NSLog(error.localizedDescription)
                }
            }
        }
    }
}
