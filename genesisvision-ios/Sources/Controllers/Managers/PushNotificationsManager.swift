//
//  PushNotificationsManager.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 30.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation

enum NotificationLocationType: String {
    case user = "User"
    case program = "Program"
    case fund = "Fund"
    case follow = "Follow"
    case tradingAccount = "TradingAccount"
    case socialPost = "SocialPost"
    case socialMediaPost = "SocialMediaPost"
    case dashboard = "Dashboard"
    case externalUrl = "ExternalUrl"
    case nothing = "Nothing"
}

struct NotificationDestination {
    let location: NotificationLocationType
    let entityId: String
    let destinationUrl: String
}

final class PushNotificationsManager {
    
    static let shared = PushNotificationsManager()

    private init() { }

    func parsePushNotification(userInfo: [AnyHashable: Any]) -> NotificationDestination? {
        guard let jsonText = userInfo["result"] as? String,
              let data = jsonText.data(using: .utf8),
              let notificationModel = CodableHelper.decode(NotificationViewModel.self, from: data).decodableObj
        else { return nil }
        
        guard let location = notificationModel.location?.location, let notificationLocationType = NotificationLocationType(rawValue: location) else {
            return NotificationDestination(location: .nothing, entityId: "", destinationUrl: "")
        }
        
        let destinationUrl = notificationModel.location?.externalUrl ?? ""
        let entityId = notificationModel.location?._id?.uuidString ?? ""
        
        return NotificationDestination(location: notificationLocationType, entityId: entityId, destinationUrl: destinationUrl)
    }
}

