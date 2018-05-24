//
//  BaseTabBarController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        showNewVersionAlertIfNeeded(self)
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.TabBar.bg
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let items = tabBar.items {
            for item in items {
                if UIDevice.current.userInterfaceIdiom != .pad {
                    item.titlePositionAdjustment = UIOffsetMake(0, -4)
                }
            }
        }
    }
}
