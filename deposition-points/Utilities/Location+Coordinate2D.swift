//
//  Location+Coordinate2D.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import MapKit

extension Location {
    init(coordinate: CLLocationCoordinate2D) {
        longitude = coordinate.longitude
        latitude = coordinate.latitude
    }
    
    var CLLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
