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
    var isTranslucent: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if isTranslucent {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        
        navigationBar.isTranslucent = isTranslucent
        navigationBar.barTintColor = UIColor.BaseView.bg
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
