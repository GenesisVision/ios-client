//
//  AppDelegate.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase

let gcmMessageIDKey = "gcm.message_id"
let gcmModelKey = "result"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachabilityManager: ReachabilityManager?
    
    var resignActiveTime: Date?
    var passcodeViewController: PasscodeViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setup(application)
        
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
    
    private func setup(_ application: UIApplication) {
        FirebaseApp.configure()
        SwaggerClientAPI.basePath = ApiKeys.basePath
        
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.restrictRotation)
        
        setupFirstScreen()

        reachabilityManager = ReachabilityManager()
        AppearanceController.setupAppearance()
        
        showPasscodeVC()
        setupNotifications(application)
    }
    
    //Push Notifications
    private func setupNotifications(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
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

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler([.alert, .badge, .sound])
    }
    //action
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        if let modelData = userInfo[gcmModelKey] as? String {
            let dataDict: [String: String] = [gcmModelKey: modelData]
            NotificationCenter.default.post(name: .notificationDidReceive, object: nil, userInfo: dataDict)
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKeys.fcmToken)
        UserDefaults.standard.synchronize()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

