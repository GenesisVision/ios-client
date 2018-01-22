//
//  RoundedImageView.swift
//  Pexmi
//
//  Created by George Shaginyan on 08/08/16.
//  Copyright © 2016 George Shaginyan. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerSize: CGFloat = 54.0
    @IBInspectable var borderSize: CGFloat = 2.0
    @IBInspectable var customBorderColor: UIColor = .white
    @IBInspectable var borderAlpha: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        
        self.layer.cornerRadius = rect.size.width / 2
        self.layer.borderColor = customBorderColor.cgColor
        self.layer.borderWidth = borderSize
        self.layer.masksToBounds = true
    }
}
