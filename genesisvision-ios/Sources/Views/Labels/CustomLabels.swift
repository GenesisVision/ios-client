//
//  CustomLabels.swift
//  genesisvision-ios
//
//  Created by George on 29/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UILabel

class CustomLabel: UILabel {
    
    // MARK: - Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        textColor = UIColor.Cell.title
        font = UIFont.getFont(.regular, size: 12.0)
    }
}

class TitleLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.title
        font = UIFont.getFont(.regular, size: 14.0)
    }
}

class LargeTitleLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.title
        font = UIFont.getFont(.semibold, size: 18.0)
    }
}

class SubtitleLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.subtitle
        font = UIFont.getFont(.regular, size: 12.0)
    }
}

class MediumLabel: CustomLabel {
    // MARK: - Lifecycle
    override func commonInit() {
        textColor = UIColor.Cell.subtitle
        font = UIFont.getFont(.medium, size: 12.0)
    }
}
