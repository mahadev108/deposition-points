//
//  ScreenScale.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit

enum ScreenScale: CGFloat {
    case one = 1.0
    case two = 2.0
    case three = 3.0
    
    static var main: ScreenScale {
        guard let scale = ScreenScale(rawValue: UIScreen.main.scale) else {
            fatalError("Screen scale has incorrect value")
        }
        return scale
    }
}

extension ScreenScale {
    var dpi: String {
        switch self {
        case .one:
            return "mdpi"
        case .two:
            return "xhdpi"
        case .three:
            return "xxhdpi"
        }
    }
}
