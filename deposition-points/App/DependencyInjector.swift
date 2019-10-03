//
//  DependencyInjector.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit

class DependencyInjector {
    static func injectDependencies(for mapViewController: MapViewController) {
        guard let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { fatalError("Persisent container not found") }
        let endpoint = "https://api.tinkoff.ru/v1"
        let depositionPointsNetwork = Network<DepositionPoint>(endPoint: endpoint)
        let depositionPointsNetworkProvider = DepositionPointsNetworkProvider(network: depositionPointsNetwork)
        let depositionPartnersNetwork = Network<DepositionPartner>(endPoint: endpoint)
        let depositionPartnersNetworkProvider = DepositionPartnersNetworkProvider(network: depositionPartnersNetwork)
        let downloader = ImageDownloader(endPoint: "https://static.tinkoff.ru/icons/deposition-partners-v3")
        let imageService = ImageService(downloader: downloader)
        let depositionPointsService = DepositionPointsService(depositionPointsNetworkProvider: depositionPointsNetworkProvider, depositionPartnersNetworkProvider: depositionPartnersNetworkProvider, imageService: imageService, persistentContainer: persistentContainer)
        let mapPresenter = MapPresenter(depositionPointsService: depositionPointsService)
        mapPresenter.view = mapViewController
        mapViewController.output = mapPresenter
    }
}
