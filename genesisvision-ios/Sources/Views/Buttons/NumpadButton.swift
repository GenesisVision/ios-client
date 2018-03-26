//
//  NumpadButton.swift
//  genesisvision-ios
//
//  Created by George on 25/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIButton

class NumpadButton: UIButton {
    
    var cornerSize: CGFloat = 5.0
    var fontSize: CGFloat = 25.0
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = cornerSize
        layer.masksToBounds = true

        titleLabel?.font = UIFont.getFont(.regular, size: fontSize)
        setTitleColor(UIColor.Font.numPadText, for: .normal)
        
        backgroundColor = UIColor.Button.numpadBackground
    }
    
    // MARK: - Public methods
    func setActiveButton(value: Bool) {
        alpha = value ? 1.0 : 0.5
        isUserInteractionEnabled = value
    }
}

