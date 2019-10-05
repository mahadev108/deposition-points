//
//  UIImage+Ext.swift
//  deposition-points
//
//  Created by laGrunge on 10/5/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(color: UIColor) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { fatalError() }
        self.init(cgImage: cgImage)
    }
}
