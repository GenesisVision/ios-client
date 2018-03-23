//
//  GradientView.swift
//  genesisvision-ios
//
//  Created by George on 23/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIView

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.init(white: 1, alpha: 0).cgColor,
            UIColor.white.cgColor
        ]
        backgroundColor = UIColor.clear
    }
}
