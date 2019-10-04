//
//  CDImageResource+Ext.swift
//  deposition-points
//
//  Created by laGrunge on 10/4/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

extension CDImageResource: StructConvertible {
    func asStruct() -> ImageResource {
        return ImageResource(name: uniqueId!, localPath: localPath!, lastModified: lastModified!)
    }
}

extension CDImageResource: Persistable {
    static var entityName: String {
        return "CDImageResource"
    }
}

extension ImageResource: CoreDataRepresentable {
    var uniqueId: String {
        return name
    }
    
    func update(entity: CDImageResource) {
        entity.uniqueId = name
        entity.localPath = localPath
        entity.lastModified = lastModified
    }
}
