//
//  NotificationsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class NotificationsDataProvider: DataProvider {
    static func getNotifications(skip: Int, take: Int, completion: @escaping (_ notificationList: NotificationList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.v10NotificationsGet(authorization: authorization, skip: skip, take: take) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}

