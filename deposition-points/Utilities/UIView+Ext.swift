//
//  UIView+Ext.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit

extension UIView {
    class var defaultReuseIdentifier: String {
        return String(describing: type(of: self))
    }
}
