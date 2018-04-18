//
//  BalanceLabel.swift
//  genesisvision-ios
//
//  Created by George on 09/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UILabel

class BalanceLabel: UILabel {
    
    var currency: String = "GVT"
    var shortView: Bool = true
    
    var amountValue: Double = 0.0 {
        didSet {
            text = getText
        }
    }
    
    override var text: String? {
        didSet {
//            print(text ?? "")
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        font = UIFont.getFont(.light, size: 25)
        
        textColor = UIColor.Font.dark
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateLayout))
        tapGesture.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private methods
    @objc private func updateLayout() {
        shortView = !shortView
        text = getText
    }
    
    var getText: String {
        return shortView ? (amountValue != 0 ? amountValue.kmFormatted + "\u{2022}" : amountValue.kmFormatted) : amountValue.rounded(withCurrency: currency).toString()
    }
}
