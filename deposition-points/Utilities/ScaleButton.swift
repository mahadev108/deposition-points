//
//  ScaleButton.swift
//  deposition-points
//
//  Created by laGrunge on 10/5/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import UIKit

class ScaleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let transparentWhite = UIColor.white.withAlphaComponent(0.5)
        setBackgroundImage(UIImage(color: transparentWhite), for: .normal)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
