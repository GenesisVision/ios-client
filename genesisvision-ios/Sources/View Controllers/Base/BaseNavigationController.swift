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
//    var shadowView: ShadowView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.Cell.bg.withAlphaComponent(0.0)
        
        applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(themeChangedNotification(notification:)), name: .themeChanged, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topViewController = self.topViewController else {
            return AppearanceController.theme == .darkTheme ? .lightContent : .default
        }
      
        switch topViewController {
        case is ProgramInvestViewController, is ProgramWithdrawViewController, is InfoViewController:
            return .lightContent
        default:
            return AppearanceController.theme == .darkTheme ? .lightContent : .default
        }
    }
    
    // MARK: - Private methods
    @objc private func themeChangedNotification(notification: Notification) {
        applyTheme()
    }
    
    private func applyTheme() {
        navigationBar.barTintColor = UIColor.NavBar.colorScheme().backgroundColor
        navigationBar.tintColor = UIColor.NavBar.colorScheme().textColor
    }
}
