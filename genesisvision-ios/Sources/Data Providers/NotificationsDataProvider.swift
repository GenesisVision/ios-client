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
        
        NotificationsAPI.v10NotificationsGet(authorization: authorization, skip: skip, take: take) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getSettings(completion: @escaping (_ notificationSettingList: NotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.v10NotificationsSettingsGet(authorization: authorization) { (model, error) in
            DataProvider().responseHandler(model, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func addSetting(assetId: String?, managerId: String?, type: NotificationsAPI.ModelType_v10NotificationsSettingsAddPost?, conditionType: NotificationsAPI.ConditionType_v10NotificationsSettingsAddPost?, conditionAmount: Double?, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId,
            let assetUUID = UUID(uuidString: assetId),
            let managerId = managerId,
            let managerUUID = UUID(uuidString: managerId)
        else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.v10NotificationsSettingsAddPost(authorization: authorization, assetId: assetUUID, managerId: managerUUID, type: type, conditionType: conditionType, conditionAmount: conditionAmount) { (uuid, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    completion(uuid?.uuidString)
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }
    
    static func removeSetting(settingId: String?, completion: @escaping CompletionBlock) {

        guard let authorization = AuthManager.authorizedToken,
            let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.v10NotificationsSettingsRemoveByIdPost(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func enableSetting(settingId: String?, enable: Bool, completion: @escaping (_ uuid: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let settingId = settingId,
            let uuid = UUID(uuidString: settingId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        NotificationsAPI.v10NotificationsSettingsByIdByEnablePost(id: uuid, enable: enable, authorization: authorization) { (uuid, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    completion(uuid?.uuidString)
                case .failure:
                    errorCompletion(result)
                }
            })
        }
    }

    static func getSettings(settingId: String?, assetType: AssetType, programCompletion: @escaping (_ programNotificationSettingList: ProgramNotificationSettingList?) -> Void, fundCompletion: @escaping (_ fundNotificationSettingList: FundNotificationSettingList?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken,
            let settingId = settingId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        switch assetType {
        case .program:
            NotificationsAPI.v10NotificationsSettingsProgramsByIdGet(id: settingId, authorization: authorization) { (model, error) in
                DataProvider().responseHandler(model, error: error, successCompletion: programCompletion, errorCompletion: errorCompletion)
            }
        case .fund:
            NotificationsAPI.v10NotificationsSettingsFundsByIdGet(id: settingId, authorization: authorization) { (model, error) in
                DataProvider().responseHandler(model, error: error, successCompletion: fundCompletion, errorCompletion: errorCompletion)
            }
        default:
            break
        }
        
    }
}

