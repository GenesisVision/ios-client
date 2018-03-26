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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.dark,
                                                            NSAttributedStringKey.font: UIFont.getFont(.bold, size: 18)]
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.dark]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.dark]
        }
        
        UINavigationBar.appearance().tintColor = UIColor.NavBar.tint
        UINavigationBar.appearance().backgroundColor = UIColor.NavBar.background
    }
    
    // TabBar
    private static func setupTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.TabBar.unselected,
                                                          NSAttributedStringKey.font: UIFont.getFont(.bold, size: 8)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.TabBar.tint,
                                                          NSAttributedStringKey.font: UIFont.getFont(.bold, size: 8)], for: .selected)

        UITabBar.appearance().tintColor = UIColor.TabBar.tint
        UITabBar.appearance().backgroundColor = UIColor.TabBar.background
    }
    
    // MARK: - IQKeyboardManager
    private static func turnIQKeyboardManager(enable: Bool, enableAutoToolbar: Bool, shouldResignOnTouchOutside: Bool) {
        IQKeyboardManager.sharedManager().enable = enable
        IQKeyboardManager.sharedManager().enableAutoToolbar = enableAutoToolbar
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = shouldResignOnTouchOutside
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 32.0
        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor.primary
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Dismiss"
        IQKeyboardManager.sharedManager().placeholderFont = UIFont.getFont(.regular, size: 14.0)
    }
}

