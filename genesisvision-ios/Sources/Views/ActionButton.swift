//
//  ActionButton.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIButton

@IBDesignable class ActionButton: UIButton {
    
    @IBInspectable var cornerSize: CGFloat = 6.0
    @IBInspectable var borderSize: CGFloat = 0.0
    @IBInspectable var customBorderColor: UIColor? = .white
    @IBInspectable var borderAlpha: CGFloat = 1.0
    @IBInspectable var fontSize: CGFloat = 14.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = cornerSize
        self.layer.borderColor = customBorderColor?.withAlphaComponent(borderAlpha).cgColor
        self.layer.borderWidth = borderSize
        self.layer.masksToBounds = true
        
        titleLabel?.font = UIFont.getFont(.bold, size: fontSize)
        titleLabel?.textColor = UIColor.Font.white
        backgroundColor = UIColor.Button.primary
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
