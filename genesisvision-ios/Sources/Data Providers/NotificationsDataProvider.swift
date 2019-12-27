//
//  NotificationsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class NotificationsDataProvider: DataProvider {
    static func get(skip: Int, take: Int, completion: @escaping (_ notificationList: NotificationList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotifications(authorization: authorization, skip: skip, take: take) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getNewCount(skip: Int, take: Int, completion: @escaping (Int?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNewNotificationsCount(authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Settings
    static func readSetting(settingId: String?, completion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.readNotification(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func getSettings(completion: @escaping (_ notificationSettingList: NotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsSettings(authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func enableSetting(settingId: String?, enable: Bool, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.toggleNotificationSettings(id: uuid, enable: enable, authorization: authorization) { (uuid, error) in
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
    static func addSetting(assetId: String? = nil, managerId: String? = nil, type: NotificationsAPI.ModelType_addNotificationsSettings? = nil, conditionType: NotificationsAPI.ConditionType_addNotificationsSettings? = nil, conditionAmount: Double? = nil, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        var assetUUID: UUID? = nil
        if let assetId = assetId {
            assetUUID = UUID(uuidString: assetId)
        }
        
        var managerUUID: UUID? = nil
        if let managerId = managerId {
            managerUUID = UUID(uuidString: managerId)
        }
        NotificationsAPI.addNotificationsSettings(authorization: authorization, assetId: assetUUID, managerId: managerUUID, type: type, conditionType: conditionType, conditionAmount: conditionAmount) { (uuid, error) in
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
        
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsProgramSettings(id: assetId, authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSettings(fundId assetId: String?, completion: @escaping (FundNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsFundSettings(id: assetId, authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSettings(managerId assetId: String?, completion: @escaping (ManagerNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.getNotificationsManagerSettings(id: assetId, authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func removeSetting(settingId: String?, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.removeNotificationsSettings(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}

