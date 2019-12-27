//
//  AppearanceController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import PKHUD

enum ThemeType: String {
    case `default`, dark
}

enum NavBarType {
    case white, primary, gray
}

struct NavBarColors {
    var tintColor: UIColor
    var backgroundColor: UIColor
    var textColor: UIColor
    var subtitleColor: UIColor
}

struct AppearanceController {
    enum Theme: Int {
        case darkTheme, lightTheme
         
        var mainColor: UIColor {
            switch self {
            case .darkTheme:
                return UIColor.primary
            case .lightTheme:
                return UIColor.primary
            }
        }
        
        //Customizing the Navigation Bar
        var barStyle: UIBarStyle {
            switch self {
            case .lightTheme:
                return .black
            case .darkTheme:
                return .default
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .lightTheme:
                return UIColor.Common.lightBackground
            case .darkTheme:
                return UIColor.Common.darkCell
            }
        }
        
        var secondaryColor: UIColor {
            switch self {
            case .lightTheme:
                return UIColor.Common.darkTextSecondary
            case .darkTheme:
                return UIColor.Common.dark
            }
        }
        
        var titleTextColor: UIColor {
            switch self {
            case .lightTheme:
                return UIColor.Common.lightTextPrimary
            case .darkTheme:
                return UIColor.Common.darkTextPrimary
            }
        }
        var subtitleTextColor: UIColor {
            switch self {
            case .lightTheme:
                return UIColor.Common.darkTextSecondary
            case .darkTheme:
                return UIColor.Common.dark
            }
        }
    }
    
    static var theme: Theme {
        get {
            let colorTheme = UserDefaults.standard.integer(forKey: UserDefaultKeys.colorTheme)
            guard let themeType = Theme(rawValue: colorTheme) else {
                return .darkTheme
            }
            
            return themeType
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultKeys.colorTheme)
        }
    }
    
    static func setupAppearance() {
        setupNavigationBar()
        turnIQKeyboardManager(enable: true, enableAutoToolbar: true, shouldResignOnTouchOutside: true)
        
        applyTheme()
        
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
    }
    
    static func applyTheme() {
        NotificationCenter.default.post(name: .themeChanged, object: nil)
        
        let theme = AppearanceController.theme
        
        UserDefaults.standard.set(theme.rawValue, forKey: UserDefaultKeys.colorTheme)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = UIColor.primary
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        
        UITabBar.appearance().barStyle = theme.barStyle

        setupTabBar()
        setupPlateCell()
        setupShadowView()
    }
    
    // NavigationBar
    static func setupNavigationBar(with type: NavBarType = .gray) {
        let colors = UIColor.NavBar.colorScheme(with: type)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: colors.textColor,
                                                            NSAttributedString.Key.font: UIFont.getFont(.semibold, size: 18)]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colors.textColor]
        }
        
        UINavigationBar.appearance().tintColor = colors.textColor
        
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "img_back_arrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "img_back_arrow")
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.getFont(.semibold, size: 14)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.getFont(.semibold, size: 14)], for: .focused)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.getFont(.semibold, size: 14)], for: .highlighted)
    }
    
    // TabBar
    private static func setupTabBar() {
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.TabBar.unselected,
                                                          NSAttributedString.Key.font: UIFont.getFont(.bold, size: 8)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.TabBar.tint,
                                                          NSAttributedString.Key.font: UIFont.getFont(.bold, size: 8)], for: .selected)

        UITabBar.appearance().tintColor = UIColor.TabBar.tint
        UITabBar.appearance().backgroundColor = UIColor.TabBar.bg
    }
    
    // MARK: - IQKeyboardManager
    private static func turnIQKeyboardManager(enable: Bool, enableAutoToolbar: Bool, shouldResignOnTouchOutside: Bool) {
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.enableAutoToolbar = enableAutoToolbar
        IQKeyboardManager.shared.shouldResignOnTouchOutside = shouldResignOnTouchOutside
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 32.0
        IQKeyboardManager.shared.toolbarTintColor = UIColor.primary
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Dismiss"
        IQKeyboardManager.shared.placeholderFont = UIFont.getFont(.regular, size: 14.0)
    }
    
    // MARK: - PlateCell
    private static func setupPlateCell() {
        PlateTableViewCell.appearance().plateAppearance =
            PlateTableViewCellAppearance(cornerRadius: Constants.SystemSizes.cornerSize,
                                         horizontalMarginValue: Constants.SystemSizes.Cell.horizontalMarginValue,
                                         verticalMarginValues: Constants.SystemSizes.Cell.verticalMarginValues,
                                         backgroundColor: UIColor.Cell.bg,
                                         selectedBackgroundColor: UIColor.Background.gray)
    }
    
    // MARK: - ShadowView
    private static func setupShadowView() {
        ShadowView.appearance().shadowViewAppearance =
            ShadowViewAppearance(shadowOpacity: 0.14,
                                 shadowColor: UIColor.Font.black,
                                 shadowRadius: 3)
    }
}
