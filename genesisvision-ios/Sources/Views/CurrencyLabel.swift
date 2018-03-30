//
//  CurrencyLabel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class CurrencyLabel: UILabel {

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        font = UIFont.getFont(.bold, size: 10)
        
        layer.backgroundColor = UIColor.Font.primary.cgColor
        textColor = UIColor.Font.white
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
}

class WhiteCurrencyLabel: CurrencyLabel {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        layer.backgroundColor = UIColor.Font.white.cgColor
        textColor = UIColor.Font.primary
    }
}
