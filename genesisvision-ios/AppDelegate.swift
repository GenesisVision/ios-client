//
//  AppDelegate.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var reachabilityManager: ReachabilityManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.restrictRotation) {
            return UIInterfaceOrientationMask.landscape
        }
        
        return UIInterfaceOrientationMask.portrait
    }
}

// MARK: - Setup
extension AppDelegate {
    private func setup() {
        SwaggerClientAPI.basePath = Constants.Api.basePath
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.restrictRotation)
        
        setupFirstScreen()

        reachabilityManager = ReachabilityManager()
        AppearanceController.setupAppearance()
        FirebaseApp.configure()
    }
    
    private func setupFirstScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let welcomeViewController = WelcomeViewController()
        window?.rootViewController = welcomeViewController
        window?.makeKeyAndVisible()
    }
}
