//
//  RoundedImageView.swift
//  Pexmi
//
//  Created by George Shaginyan on 08/08/16.
//  Copyright © 2016 George Shaginyan. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    
    var cornerSize: CGFloat = 54.0
    var borderSize: CGFloat = 0.0
    var customBorderColor: UIColor = .white
    var borderAlpha: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = rect.size.width / 2
        self.layer.borderColor = customBorderColor.cgColor
        self.layer.borderWidth = borderSize
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderColor = customBorderColor.cgColor
        self.layer.borderWidth = borderSize
        self.layer.masksToBounds = true
    }
}
