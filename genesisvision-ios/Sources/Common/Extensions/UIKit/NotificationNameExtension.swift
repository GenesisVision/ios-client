//
//  NotificationNameExtension.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let signOut = Notification.Name(Constants.Keys.signOutKey)
    static let twoFactorEnable = Notification.Name(Constants.Keys.twoFactorEnableKey)
    static let twoFactorChange = Notification.Name(Constants.Keys.twoFactorChangeKey)
    static let programFavoriteStateChange = Notification.Name(Constants.Keys.programFavoriteStateChangeKey)
    
    static let themeChanged = Notification.Name(Constants.Keys.themeChangedKey)
}
