//
//  NotificationsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class NotificationsDataProvider: DataProvider {
    static func get(skip: Int, take: Int, completion: @escaping (_ notificationList: NotificationViewModelItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        NotificationsAPI.getNotifications(skip: skip, take: take) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getNewCount(skip: Int, take: Int, completion: @escaping (Int?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        NotificationsAPI.getNewNotificationsCount { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Settings
    static func readSetting(settingId: String?, completion: @escaping CompletionBlock) {
        
        guard let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.readNotification(_id: uuid) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func getSettings(completion: @escaping (_ notificationSettingList: NotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        NotificationsAPI.getNotificationsSettings { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func enableSetting(settingId: String?, enable: Bool, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.toggleNotificationSettings(_id: uuid, enable: enable) { (uuid, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    if let uuidString = uuid?.uuidString {
                        let uuidResult = uuidString.removeCharacters(from: "\\").removeCharacters(from: "\"")
                        completion(uuidResult)
                    }
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }
    
    static func addSetting(assetId: String? = nil, managerId: String? = nil, type: NotificationType? = nil, conditionType: NotificationSettingConditionType? = nil, conditionAmount: Double? = nil, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        var assetUUID: UUID? = nil
        if let assetId = assetId {
            assetUUID = UUID(uuidString: assetId)
        }
        
        var managerUUID: UUID? = nil
        if let managerId = managerId {
            managerUUID = UUID(uuidString: managerId)
        }
        NotificationsAPI.addNotificationsSettings(assetId: assetUUID, managerId: managerUUID, type: type, conditionType: conditionType, conditionAmount: conditionAmount) { (uuid, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    if let uuidString = uuid?.uuidString {
                        let uuidResult = uuidString.removeCharacters(from: "\\").removeCharacters(from: "\"")
                        completion(uuidResult)
                    }
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }
    
    static func getSettings(programId assetId: String?, completion: @escaping (ProgramNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsProgramSettings(_id: assetId) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSettings(followId assetId: String?, completion: @escaping (FollowNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsFollowSettings(_id: assetId) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSettings(fundId assetId: String?, completion: @escaping (FundNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsFundSettings(_id: assetId) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSettings(managerId assetId: String?, completion: @escaping (ManagerNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsManagerSettings(_id: assetId) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func removeSetting(settingId: String?, completion: @escaping CompletionBlock) {
        guard let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.removeNotificationsSettings(_id: uuid) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}

