//
//  TooltipButton.swift
//  genesisvision-ios
//
//  Created by George on 24/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIButton

protocol TooltipButtonProtocol: class {
    func showDidPress(_ tooltipText: String)
}

class TooltipButton: UIButton {
    
    weak var delegate: TooltipButtonProtocol?
    
    var tooltipText: String = ""
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        setImage(#imageLiteral(resourceName: "img_tip_icon"), for: .normal)
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
        
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.showDidPress(tooltipText)
        } else {
            let window = UIApplication.shared.windows[0]
            if let viewController = window.rootViewController as? BaseViewController {
                viewController.showBottomSheet(.text, title: tooltipText, initializeHeight: 130, completion: nil)
            }
        }
    }
}

