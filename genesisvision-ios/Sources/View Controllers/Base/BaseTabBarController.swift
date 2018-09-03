//
//  BaseTabBarController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false

        showNewVersionAlertIfNeeded(self)
        showTwoFactorEnableAlertIfNeeded(self) { (enable) in
        }
        
        applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(themeChangedNotification(notification:)), name: .themeChanged, object: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
    }
    
    // MARK: - Private methods
    @objc private func themeChangedNotification(notification: Notification) {
        applyTheme()
    }
    
    private func applyTheme() {
        tabBar.barTintColor = UIColor.TabBar.bg
    }
}
