//
//  CDDepositionPoint+Ext.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

extension CDDepositionPoint: StructConvertible {
    func asStruct() -> DepositionPoint {
        return DepositionPoint(partnerName: partnerName!, externalId: externalId!, location: Location(latitude: latitude, longitude: longitude))
    }
}

extension CDDepositionPoint: Persistable {
    static var entityName: String {
        return "CDDepositionPoint"
    }
}

extension DepositionPoint: CoreDataRepresentable {
    var uniqueId: String {
        return "\(partnerName)-\(externalId)"
    }
    
    func update(entity: CDDepositionPoint) {
        entity.partnerName = partnerName
        entity.externalId = externalId
        entity.uniqueId = uniqueId
        entity.latitude = location.latitude
        entity.longitude = location.longitude
    }
}
