//
//  GradientView.swift
//  genesisvision-ios
//
//  Created by George on 23/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIView

class GradientView: UIView {
    var colors: [CGColor] = [UIColor.BaseView.bottomGradientView.withAlphaComponent(0.0).cgColor, UIColor.BaseView.bottomGradientView.cgColor]
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = colors
    }
}
