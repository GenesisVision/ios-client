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
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
}
