//
//  Realm+Notifications.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let RealmLoadingErrorNotifications: Notification.Name =
        Notification.Name(rawValue: "RealmLoadingErrorNotifications")
    static let RealmWritingErrorNotifications: Notification.Name =
        Notification.Name(rawValue: "RealmWritingErrorNotifications")
}
