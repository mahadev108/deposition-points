//
//  DepositionPartnersNetworkProvider.swift
//  deposition-points
//
//  Created by laGrunge on 10/1/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

protocol DepositionPartnersNetworkProviderType {
    func depositionPartners(completion: @escaping DepositionPartnersCompletion)
}

final class DepositionPartnersNetworkProvider: DepositionPartnersNetworkProviderType {
    
    let network: Network<DepositionPartner>
    
    init(network: Network<DepositionPartner>) {
        self.network = network
    }
    
    func depositionPartners(completion: @escaping DepositionPartnersCompletion) {
        network.getItems(path: "deposition_partners", parameters: ["accountType": "Credit"]) { result in
            completion(result)
        }
    }
}
