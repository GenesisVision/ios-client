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
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationDidTap(_:)), name: .notificationDidTap, object: nil)
        
        if let fcmToken = UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToken) {
            sendFcmToken(fcmToken)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        guard let items = tabBar.items else { return }
        items.forEach({$0.title = ""})
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notificationDidReceive, object: nil)
        NotificationCenter.default.removeObserver(self, name: .notificationDidTap, object: nil)
    }
    
    // MARK: - Private methods
    
    @objc private func notificationDidTap(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let destination = PushNotificationsManager.shared.parsePushNotification(userInfo: userInfo) else { return }
        
        // Update ViewController when it's already at top
        switch destination.location {
        case .user:
            guard router?.topViewController() is ManagerViewController else {
                router?.showUserDetails(with: destination.entityId)
                return }
            NotificationCenter.default.post(name: .updateUserViewController, object: nil, userInfo: ["userId": destination.entityId])
        case .program:
            guard router?.topViewController() is ProgramViewController else {
                router?.showAssetDetails(with: destination.entityId, assetType: .program)
                return }
            NotificationCenter.default.post(name: .updateProgramViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .fund:
            guard router?.topViewController() is FundViewController else {
                router?.showAssetDetails(with: destination.entityId, assetType: .fund)
                return }
            NotificationCenter.default.post(name: .updateFundViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .follow:
            guard router?.topViewController() is ProgramViewController else {
                router?.showAssetDetails(with: destination.entityId, assetType: .program)
                return }
            NotificationCenter.default.post(name: .updateProgramViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .tradingAccount:
            guard router?.topViewController() is AccountViewController else {
                router?.showTradingAccountDetails(with: destination.entityId)
                return }
            NotificationCenter.default.post(name: .updateTradingAccountViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .socialPost:
            break
        case .socialMediaPost:
            break
        case .dashboard:
            guard router?.topViewController() is DashboardViewController else {
                router?.changeTab(withParentRouter: router, to: .dashboard)
                return }
            NotificationCenter.default.post(name: .updateDashboardViewController, object: nil, userInfo: nil)
        case .externalUrl:
            router?.showSafari(with: destination.destinationUrl)
        case .nothing:
            guard router?.topViewController() is NotificationListViewController else {
                router?.showNotificationList()
                return }
            NotificationCenter.default.post(name: .updateNotificationListViewController, object: nil, userInfo: nil)
        }
    }
    
    @objc private func notificationDidReceive(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let destination = PushNotificationsManager.shared.parsePushNotification(userInfo: userInfo) else { return }
        
        switch destination.location {
        case .user:
            NotificationCenter.default.post(name: .updateUserViewController, object: nil, userInfo: ["userId": destination.entityId])
        case .program:
            NotificationCenter.default.post(name: .updateProgramViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .fund:
            NotificationCenter.default.post(name: .updateFundViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .follow:
            NotificationCenter.default.post(name: .updateProgramViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .tradingAccount:
            NotificationCenter.default.post(name: .updateTradingAccountViewController, object: nil, userInfo: ["assetId": destination.entityId])
        case .socialPost:
            break
        case .socialMediaPost:
            break
        case .dashboard:
            NotificationCenter.default.post(name: .updateDashboardViewController, object: nil, userInfo: nil)
        case .externalUrl:
            break
        case .nothing:
            NotificationCenter.default.post(name: .updateNotificationListViewController, object: nil, userInfo: nil)
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
