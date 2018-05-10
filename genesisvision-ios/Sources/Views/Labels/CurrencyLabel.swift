//
//  CurrencyLabel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UILabel

@IBDesignable class RoundedLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 4.0
    @IBInspectable var bottomInset: CGFloat = 4.0
    @IBInspectable var leftInset: CGFloat = 8
    @IBInspectable var rightInset: CGFloat = 8
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        font = UIFont.getFont(.bold, size: 10)

        layer.backgroundColor = UIColor.Font.primary.cgColor
        textColor = UIColor.Font.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

class CurrencyLabel: RoundedLabel {

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.backgroundColor = UIColor.Font.primary.cgColor
        textColor = UIColor.Font.white
    }
}

class WhiteCurrencyLabel: RoundedLabel {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        layer.backgroundColor = UIColor.Font.white.cgColor
        textColor = UIColor.Font.primary
    }
}

class TournamentPlaceLabel: RoundedLabel {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.backgroundColor = UIColor.Tournament.bg.cgColor
        textColor = UIColor.Font.white
    }
}
