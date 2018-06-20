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
    
    var resignActiveTime: Date?
    var passcodeViewController: PasscodeViewController?
    
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let passcodeViewController = passcodeViewController else { return }
        
        if let resignActiveTime = resignActiveTime, Date().timeIntervalSince(resignActiveTime) < 5 {
            passcodeViewController.dismiss(animated: true, completion: nil)
        } else {
            passcodeViewController.passcodeState = .lock
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        resignActiveTime = Date()
        
        showPasscodeVC()
    }
}

// MARK: - Setup
extension AppDelegate {
    private func showPasscodeVC() {
        if UserDefaults.standard.bool(forKey: Constants.UserDefaults.passcodeEnable) {
            let window = UIApplication.shared.windows[0] as UIWindow
            if let viewController = PasscodeViewController.storyboardInstance(name: .settings), let vc = window.rootViewController {
                let router = Router(parentRouter: nil)
                viewController.viewModel = PasscodeViewModel(withRouter: router)
                viewController.passcodeState = .openApp
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overCurrentContext
                passcodeViewController = viewController
                vc.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    private func setup() {
        SwaggerClientAPI.basePath = Constants.Api.basePath
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.restrictRotation)
        
        setupFirstScreen()

        reachabilityManager = ReachabilityManager()
        AppearanceController.setupAppearance()
        FirebaseApp.configure()
        
        showPasscodeVC()
    }
    
    private func setupFirstScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let welcomeViewController = WelcomeViewController()
        window?.rootViewController = welcomeViewController
        window?.makeKeyAndVisible()
    }
}
