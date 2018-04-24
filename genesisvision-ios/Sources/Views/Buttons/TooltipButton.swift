//
//  TooltipButton.swift
//  genesisvision-ios
//
//  Created by George on 24/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIButton

class TooltipButton: UIButton {
    
    var customBorderColor: UIColor = UIColor.Font.light
    var tooltipText: String = ""
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.borderColor = customBorderColor.cgColor
        
        titleLabel?.font = UIFont.getFont(.bold, size: 13)
        setTitleColor(customBorderColor, for: .normal)
        setTitle("?", for: .normal)
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
        
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let window = UIApplication.shared.windows[0] as UIWindow
        if let viewController = window.rootViewController {
            viewController.showTooltip(with: tooltipText, for: self)
        }
    }
}

