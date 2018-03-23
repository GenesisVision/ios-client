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
        
        layer.cornerRadius = cornerSize
        layer.borderColor = customBorderColor?.withAlphaComponent(borderAlpha).cgColor
        layer.borderWidth = borderSize
        layer.masksToBounds = true
        
        titleLabel?.font = UIFont.getFont(.bold, size: fontSize)
        titleLabel?.textColor = UIColor.Font.white
        backgroundColor = UIColor.Button.primary
    }
    
    func addShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 6.0
        layer.masksToBounds = true
    }
}
