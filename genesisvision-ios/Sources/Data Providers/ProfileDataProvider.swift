//
//  ProfileDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProfileDataProvider: DataProvider {
    static func getProfileFull(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        isInvestorApp
            ? getInvestorProfileFull(with: authorization, completion: completion, errorCompletion: errorCompletion)
            : getManagerProfileFull(with: authorization, completion: completion, errorCompletion: errorCompletion)
    }
    
    static func updateProfileImage(imageURL: URL, completion: @escaping (_ token: String?) -> Void, errorCompletion: @escaping CompletionBlock) {
        FilesAPI.apiFilesUploadPost(uploadedFile: imageURL) { (uploadResultModel, error) in
           
            DataProvider().responseHandler(uploadResultModel, error: error, successCompletion: { (viewModel) in
                let uuid = uploadResultModel?.id?.uuidString
                completion(uuid)
            }, errorCompletion: errorCompletion)
        }
    }
    
    static func updateProfile(model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isInvestorApp
            ? updateInvestorProfile(with: authorization, model: model, completion: completion)
            : updateManagerProfile(with: authorization, model: model, completion: completion)
    }
    
    // MARK: - Private methods
    private static func getInvestorProfileFull(with authorization: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorProfileFullGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: { (profileViewModel) in
                completion(profileViewModel)
            }, errorCompletion: errorCompletion)
        }
    }
    
    private static func getManagerProfileFull(with authorization: String, completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerProfileFullGet(authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    private static func updateInvestorProfile(with authorization: String, model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        InvestorAPI.apiInvestorProfileUpdatePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    private static func updateManagerProfile(with authorization: String, model: UpdateProfileViewModel, completion: @escaping CompletionBlock) {
        ManagerAPI.apiManagerProfileUpdatePost(authorization: authorization, model: model) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
