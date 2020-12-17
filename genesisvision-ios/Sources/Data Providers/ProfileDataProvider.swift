//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileDataProvider: DataProvider {
    
    static func getMobileVErificationTokens(completion: @escaping (_ profile: ExternalKycAccessToken?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        ProfileAPI.getMobileVerificationToken { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        ProfileAPI.getProfileFull { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getHeader(completion: @escaping (ProfileHeaderViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        ProfileAPI.getProfileHeader { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func updateProfile(model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        
        ProfileAPI.updateProfile(body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updatePersonal(model: UpdatePersonalDetailViewModel, completion: @escaping CompletionBlock) {
        
        ProfileAPI.updatePersonalDetails(body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func updateProfileAvatar(fileId: String, completion: @escaping CompletionBlock) {
        
        ProfileAPI.updateAvatar(fileId: fileId) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Public
    static func publicChange(_ value: Bool, completion: @escaping CompletionBlock) {
        
        value ?
            ProfileAPI.switchPublicInvestorOn { (_, error) in
                DataProvider().responseHandler(error, completion: completion)
            }
            :
            ProfileAPI.switchPublicInvestorOff { (_, error) in
                DataProvider().responseHandler(error, completion: completion)
            }
    }
    
    // MARK: - Push notifications
    static func addFCMToken(token: String, completion: @escaping CompletionBlock) {
        
        let token = FcmTokenViewModel(token: token, platform: .ios)
        
        ProfileAPI.updateFcmToken(body: token) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func removeFCMToken(token: String, completion: @escaping CompletionBlock) {
        
        let token = FcmTokenViewModel(token: token)
                
        ProfileAPI.removeFcmToken(body: token) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Social links
    static func getSocialLinks(completion: @escaping (SocialLinksViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        ProfileAPI.getSocialLinks { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func updateSocialLinks(model: UpdateSocialLinksViewModel?, completion: @escaping CompletionBlock) {
        
        ProfileAPI.updateAllSocialLinks(body: model) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
