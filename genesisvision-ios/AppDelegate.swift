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
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.restrictRotation) ? .landscape : .portrait
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let passcodeViewController = passcodeViewController, topViewController() == passcodeViewController else { return }
        
        if let resignActiveTime = resignActiveTime, Date().timeIntervalSince(resignActiveTime) < Security.timeInterval {
            passcodeViewController.dismiss(animated: true, completion: nil)
            self.resignActiveTime = nil
        } else {
            passcodeViewController.passcodeState = .lock
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if (topViewController() as? PasscodeViewController) != nil {
            return
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.passcodeEnable) {
            resignActiveTime = Date()
            showPasscodeVC()
        }
    }
}

// MARK: - Setup
extension AppDelegate {
    private func showPasscodeVC() {
        
        if (topViewController() as? PasscodeViewController) != nil {
            return
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.passcodeEnable) {
            let window = UIApplication.shared.windows[0] as UIWindow
            if let viewController = PasscodeViewController.storyboardInstance(.settings), let vc = window.rootViewController {
                let router = Router(parentRouter: nil)
                viewController.viewModel = PasscodeViewModel(withRouter: router)
                viewController.delegate = self
                viewController.passcodeState = .openApp
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overCurrentContext
                passcodeViewController = viewController
                vc.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    private func setup() {
        SwaggerClientAPI.basePath = Api.basePath
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.restrictRotation)
        
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
    
    private func topViewController() -> UIViewController? {
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                return presentedViewController
            }
        }
        
        return nil
    }
}

extension AppDelegate: PasscodeProtocol {
    func passcodeAction(_ action: PasscodeActionType) {
        switch action {
        default:
            resignActiveTime = nil
        }
    }
}
