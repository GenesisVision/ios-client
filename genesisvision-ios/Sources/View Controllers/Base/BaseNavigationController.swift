//
//  BaseNavigationController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    // MARK: - Variables
    var isTranslucent: Bool = false {
        didSet {
            if isTranslucent {
                navigationBar.setBackgroundImage(UIImage(), for: .default)
            }
            
            navigationBar.isTranslucent = isTranslucent
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        if isTranslucent {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        
        navigationBar.isTranslucent = isTranslucent
        navigationBar.barTintColor = UIColor.BaseView.bg
        navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "img_back_arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "img_back_arrow")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
