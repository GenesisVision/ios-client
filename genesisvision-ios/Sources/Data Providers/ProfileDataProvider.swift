//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileDataProvider: DataProvider {
    static func getProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.getProfileFull(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getHeader(completion: @escaping (ProfileHeaderViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.getProfileHeader(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func updateProfile(model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.updateProfile(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updatePersonal(model: UpdatePersonalDetailViewModel, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.updatePersonalDetails(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updateProfileAvatar(fileId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.updateAvatar(fileId: fileId, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Public
    static func publicChange(_ value: Bool, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        value ?
            ProfileAPI.switchPublicInvestorOn(authorization: authorization) { (error) in
                DataProvider().responseHandler(error, completion: completion)
            }
            :
            ProfileAPI.switchPublicInvestorOff(authorization: authorization) { (error) in
                DataProvider().responseHandler(error, completion: completion)
            }
    }
    
    // MARK: - Push notifications
    static func addFCMToken(token: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let token = FcmTokenViewModel(token: token)
        
        ProfileAPI.updateFcmToken(authorization: authorization, token: token) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func removeFCMToken(token: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let token = FcmTokenViewModel(token: token)
        
        ProfileAPI.removeFcmToken(authorization: authorization, token: token) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Social links
    static func getSocialLinks(completion: @escaping (SocialLinksViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.getSocialLinks(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func updateSocialLinks(model: UpdateSocialLinksViewModel?, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProfileAPI.updateAllSocialLinks(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
