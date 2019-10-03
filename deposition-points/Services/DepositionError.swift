//
//  DepositionError.swift
//  deposition-points
//
//  Created by laGrunge on 10/1/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

enum DefaultError: Error {
    case urlError
    case networkUnavailable
    case wrongDataFormat
}

extension DefaultError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Could not create a URL.", comment: "")
        case .networkUnavailable:
            return NSLocalizedString("Could not get data from the remote server.", comment: "")
        case .wrongDataFormat:
            return NSLocalizedString("Could not digest the fetched data.", comment: "")
        }
    }
}
