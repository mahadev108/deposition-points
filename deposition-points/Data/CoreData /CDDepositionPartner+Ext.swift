//
//  CDDepositionPartner+Ext.swift
//  deposition-points
//
//  Created by laGrunge on 10/1/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

extension CDDepositionPartner: StructConvertible {
    func asStruct() -> DepositionPartner {
        return DepositionPartner(id: uniqueId!, name: name!, picture: picture!)
    }
}

extension CDDepositionPartner: Persistable {
    static var entityName: String {
        return "CDDepositionPartner"
    }
}

extension DepositionPartner: CoreDataRepresentable {
    var uniqueId: String {
        return id
    }
    
    func update(entity: CDDepositionPartner) {
        entity.uniqueId = id
        entity.name = name
        entity.picture = picture
    }
}
