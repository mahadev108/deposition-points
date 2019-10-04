//
//  MapPresenter.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit

class MapPresenter {
    weak var view: MapViewControllerInput!
    var depositionPointsService: DepositionPointsServiceType
    
    init(depositionPointsService: DepositionPointsServiceType) {
        self.depositionPointsService = depositionPointsService
        self.depositionPointsService.listener = self
    }
}

extension MapPresenter: MapViewControllerOutput {
    func visibleMapRegionChanged(center location: Location, bufferRadius radius: Double, bufferMinLongitude: Double, bufferMaxLongitude: Double, bufferMinLatitude: Double, bufferMaxLatitude: Double) {
        let searchParams = DepositionPointsSearchParams(center: location, radius: radius, maxLatitude: bufferMaxLatitude, maxLongitude: bufferMaxLongitude, minLatitude: bufferMinLatitude, minLongitude: bufferMinLongitude)
        depositionPointsService.setSearchParams(searchParams)
    }
}

extension MapPresenter: DepositionPointsServiceListener {
    func depositionPoints(_ points: [DepositionPoint]) {
        view.showPoints(points)
    }
    
    func icon(for point: DepositionPoint, completion: @escaping (UIImage?) -> Void) {
        depositionPointsService.partnerImage(for: point) { (data) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
