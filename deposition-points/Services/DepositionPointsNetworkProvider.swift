//
//  DepositionPointsNetworkProvider.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

protocol DepositionPointsNetworkProviderType {
    func depositionPoints(with: DepositionPointsSearchParams, completion: @escaping DepositionPointsCompletion)
}

final class DepositionPointsNetworkProvider: DepositionPointsNetworkProviderType {
    
    private let network: Network<DepositionPoint>
    
    init(network: Network<DepositionPoint>) {
        self.network = network
    }
    
    func depositionPoints(with params: DepositionPointsSearchParams, completion: @escaping DepositionPointsCompletion) {
        network.getItems(path: "deposition_points", parameters: ["latitude": params.center.latitude, "longitude": params.center.longitude, "radius": Int(params.radius)]) { result in
            completion(result)
        }
    }
    
}
