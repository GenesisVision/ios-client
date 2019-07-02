//
//  CustomTextField.swift
//  genesisvision-ios
//
//  Created by George on 29/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITextField

class InputTextField: UITextField {
    
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
        font = UIFont.getFont(.regular, size: 18.0)
    }
}
