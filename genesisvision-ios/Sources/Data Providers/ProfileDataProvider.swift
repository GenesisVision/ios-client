//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileDataProvider: DataProvider {
    static func getProfileFull(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.v10ProfileGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: errorCompletion)
        }
    }
    
    static func updateProfile(model: UpdatePersonalDetailViewModel, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.v10ProfilePersonalUpdatePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func updateProfileAvatar(fileId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.v10ProfileAvatarUpdateByFileIdPost(fileId: fileId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func addFCMToken(token: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let token = FcmTokenViewModel(token: token)
        
        ProfileAPI.v10ProfilePushTokenPost(authorization: authorization, token: token) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
