//
//  NotificationNameExtension.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let signOut = Notification.Name(Keys.signOutKey)
    static let twoFactorEnable = Notification.Name(Keys.twoFactorEnableKey)
    static let twoFactorChange = Notification.Name(Keys.twoFactorChangeKey)
    static let programFavoriteStateChange = Notification.Name(Keys.programFavoriteStateChangeKey)
    static let followFavoriteStateChange = Notification.Name(Keys.followFavoriteStateChangeKey)
    static let fundFavoriteStateChange = Notification.Name(Keys.fundFavoriteStateChangeKey)
    static let notificationDidReceive = Notification.Name(Keys.notificationDidReceiveKey)
    static let chooseProgramList = Notification.Name(Keys.chooseProgramListKey)
    static let chooseFundList = Notification.Name(Keys.chooseFundListKey)
    
    static let tabBarDidScrollToTop = Notification.Name(Keys.tabBarDidScrollToTopKey)
    
    static let themeChanged = Notification.Name(Keys.themeChangedKey)
}
