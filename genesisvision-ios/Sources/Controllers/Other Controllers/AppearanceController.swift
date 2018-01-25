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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = UIColor(.blue)
    }
    
    // TabBar
    private static func setupTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .selected)
        UITabBar.appearance().tintColor = .black
    }
    
    // MARK: - IQKeyboardManager
    private static func turnIQKeyboardManager(enable: Bool, enableAutoToolbar: Bool, shouldResignOnTouchOutside: Bool) {
        IQKeyboardManager.sharedManager().enable = enable
        IQKeyboardManager.sharedManager().enableAutoToolbar = enableAutoToolbar
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = shouldResignOnTouchOutside
    }
}

