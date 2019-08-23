//
//  BaseTabBarController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vison. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    var router: Router? = nil
    var previousViewController: UIViewController?

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        delegate = self
        showNewVersionAlertIfNeeded(self)
        showTwoFactorEnableAlertIfNeeded(self) { (enable) in
        }
        
        applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(themeChangedNotification(notification:)), name: .themeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationDidReceive(_:)), name: .notificationDidReceive, object: nil)
        
        if let fcmToken = UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToken) {
            sendFcmToken(fcmToken)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let items = tabBar.items {
            for item in items {
                if UIDevice.current.userInterfaceIdiom != .pad {
                    item.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notificationDidReceive, object: nil)
    }
    
    // MARK: - Private methods
    @objc private func notificationDidReceive(_ notification: Notification) {
        if let jsonText = notification.userInfo?["result"] as? String {

            if let data = jsonText.data(using: .utf8) {
                do {
                    guard let dictonary: Dictionary<String, Any> = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                    
                    if let settingId = dictonary["Id"] as? String {
                        NotificationsDataProvider.readSetting(settingId: settingId) { (result) in
                            print(result)
                        }
                    }
                    
                    if let assetId = dictonary["AssetId"] as? String,
                        let type = dictonary["AssetType"] as? String,
                        let assetType = AssetType(rawValue: type.capitalized) {
                        
                        
                        
                        router?.showAssetDetails(with: assetId, assetType: assetType)
                    } else {
                        router?.showNotificationList()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    @objc private func themeChangedNotification(notification: Notification) {
        applyTheme()
    }
    
    @objc private func sendFcmToken(_ fcmToken: String) {
        ProfileDataProvider.addFCMToken(token: fcmToken) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
            }
        }
    }
    
    private func applyTheme() {
        tabBar.barTintColor = UIColor.TabBar.bg
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        guard previousViewController == viewController,
            let tabsType = TabsType(rawValue: tabBarIndex) else { return }

        let userInfo: [String: TabsType] = ["type": tabsType]
        
        NotificationCenter.default.post(name: .tabBarDidScrollToTop, object: nil, userInfo: userInfo)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        previousViewController = tabBarController.selectedViewController
        return true
    }
}
