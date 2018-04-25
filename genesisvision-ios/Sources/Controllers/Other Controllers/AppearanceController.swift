//
//  AppearanceController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum ColorStyle {
    case white, primary, gray
}

struct StyleColors {
    var tintColor = UIColor.NavBar.tint
    var backgroundColor = UIColor.NavBar.background
    var textColor = UIColor.Font.dark
    var subtitleColor = UIColor.Font.medium
    
    init(with style: ColorStyle = .white) {
        switch style {
        case .primary:
            self.tintColor = UIColor.Font.white
            self.backgroundColor = UIColor.primary
            self.textColor = UIColor.Font.white
            self.subtitleColor = UIColor.Font.white.withAlphaComponent(0.5)
        case .gray:
            self.backgroundColor = UIColor.NavBar.grayBackground
        default:
            self.tintColor = UIColor.NavBar.tint
            self.backgroundColor = UIColor.NavBar.background
            self.textColor = UIColor.Font.dark
        }
    }
}

struct AppearanceController {
    static func setupAppearance() {
        setupNavigationBar()
        setupTabBar()
        turnIQKeyboardManager(enable: true, enableAutoToolbar: true, shouldResignOnTouchOutside: true)
        
        setupSegmentedControl()
        
        setupEasyTipView()
    }
    
    // NavigationBar
    static func setupNavigationBar(with style: ColorStyle = .white) {
        let colors = StyleColors(with: style)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.textColor,
                                                            NSAttributedStringKey.font: UIFont.getFont(.bold, size: 18)]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.textColor]
        }
        
        UINavigationBar.appearance().tintColor = colors.tintColor
        UINavigationBar.appearance().backgroundColor = colors.backgroundColor
        
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "img_back_arrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "img_back_arrow")
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
    
    // MARK: - SegmentedControl
    private static func setupSegmentedControl() {
        let segmentedControlAppearance = ScrollableSegmentedControl.appearance()
        segmentedControlAppearance.segmentContentColor = UIColor.Font.light
        segmentedControlAppearance.selectedSegmentContentColor = UIColor.primary
        segmentedControlAppearance.backgroundColor = UIColor.clear
        segmentedControlAppearance.tintColor = UIColor.primary
        segmentedControlAppearance.borderColor = UIColor.primary
        segmentedControlAppearance.borderWidth = 2
    }
    
    // MARK: - EasyTipView
    private static func setupEasyTipView() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.getFont(.regular, size: 15)
        preferences.drawing.foregroundColor = UIColor.Font.white
        preferences.drawing.backgroundColor = UIColor.primary
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        preferences.drawing.shadowColor = UIColor.Font.dark
        preferences.drawing.shadowOpacity = 0.5
        preferences.drawing.shadowRadius = 3.0
        preferences.drawing.shadowOffset = CGSize(width: 2.0, height: 2.0)
        preferences.hasShadow = true
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 0.3
        preferences.animating.dismissDuration = 0.3
        preferences.animating.captureAllTaps = true
        
        EasyTipView.globalPreferences = preferences
    }
}
