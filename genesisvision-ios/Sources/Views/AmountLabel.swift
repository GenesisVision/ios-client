//
//  AmountLabel.swift
//  genesisvision-ios
//
//  Created by George on 28/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UILabel

class AmountLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = UIFont.getFont(.light, size: 72)
        self.textColor = UIColor.Font.amountPlaceholder
    }
    
    override var text: String? {
        didSet {
            if let text = text, let doubleValue = text.doubleValue {
                self.textColor = doubleValue > 0.0 ? UIColor.Font.amountDarkBlue : UIColor.Font.amountPlaceholder
            }
        }
    }
}
