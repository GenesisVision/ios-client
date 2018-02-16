//
//  AppearanceController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

struct AppearanceController {
    static func setupAppearance() {
        setupNavigationBar()
        setupTabBar()
        turnIQKeyboardManager(enable: true, enableAutoToolbar: true, shouldResignOnTouchOutside: true)
    }
    
    // NavigationBar
    private static func setupNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.dark]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.dark]
        }
        
        UINavigationBar.appearance().tintColor = UIColor.primary
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.primary], for: .normal)
    }
    
    // TabBar
    private static func setupTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.primary], for: .selected)
        UITabBar.appearance().tintColor = UIColor.primary
        UITabBar.appearance().backgroundColor = .white
    }
    
    // MARK: - IQKeyboardManager
    private static func turnIQKeyboardManager(enable: Bool, enableAutoToolbar: Bool, shouldResignOnTouchOutside: Bool) {
        IQKeyboardManager.sharedManager().enable = enable
        IQKeyboardManager.sharedManager().enableAutoToolbar = enableAutoToolbar
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = shouldResignOnTouchOutside
    }
}

