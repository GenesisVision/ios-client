//
//  AuthController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIApplication

class AuthManager {
    
    private static var profileViewModel: ProfileFullViewModel?
    private static var walletViewModel: WalletViewModel?
    private static var rateViewModel: RateViewModel?
    
    static var authorizedToken: String? {
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: Constants.UserDefaults.authorizedToken)
        }
        get {
            guard let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizedToken) else { return nil }
            
            return "Bearer " + token
        }
    }
    
    static func updateToken() {
        AuthManager().updateApiToken { (result) in
            switch result {
            case .success:
                print("Token updated")
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    static func signOut() {
        AuthManager.authorizedToken = nil
        AuthManager.profileViewModel = nil
        AuthManager.walletViewModel = nil
        AuthManager.rateViewModel = nil
    }
    
    static func isLogin() -> Bool {
        return AuthManager.authorizedToken != nil
    }
    
    static func getSavedRate(completion: @escaping (_ rate: Double) -> Void) {
        getRate { (viewModel) in
            completion(rateViewModel?.rate ?? 0.0)
        }
    }
    
    static func getBalance(completion: @escaping (_ balance: Double) -> Void, completionError: @escaping CompletionBlock) {
        getWallet(completion: { (viewModel) in
            completion(walletViewModel?.amount?.rounded(withType: .gvt) ?? 0.0)
        }, completionError: completionError)
    }
    
    static func saveWalletViewModel(viewModel: WalletViewModel) {
        self.walletViewModel = viewModel
    }
    
    static func saveProfileViewModel(viewModel: ProfileFullViewModel) {
        self.profileViewModel = viewModel
    }
    
    static func getProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void, completionError: @escaping CompletionBlock) {
        if let profileViewModel = profileViewModel {
            completion(profileViewModel)
        }
        
        ProfileDataProvider.getProfileFull(completion: { (viewModel) in
            if viewModel != nil  {
                profileViewModel = viewModel
            }
            
            completion(viewModel)
        }, errorCompletion: completionError)
    }
    
    static func getRate(completion: @escaping (_ rate: RateViewModel?) -> Void) {
        guard rateViewModel == nil else {
            completion(rateViewModel)
            return
        }
        
        RateDataProvider.getTake(completion: { (viewModel) in
            if viewModel != nil  {
                rateViewModel = viewModel
            }
            
            completion(rateViewModel)
        }, errorCompletion: { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        })
    }
    
    static func getWallet(completion: @escaping (_ wallet: WalletViewModel?) -> Void, completionError: @escaping CompletionBlock) {
        if let walletViewModel = walletViewModel {
            completion(walletViewModel)
        }
        
        WalletDataProvider.getWallet(completion: { (viewModel) in
            if viewModel != nil  {
                walletViewModel = viewModel?.wallets?.first
            }
            
            completion(walletViewModel)
        }, errorCompletion: completionError)
    }
    
    // MARK: - Private methods
    private func updateApiToken(completion: @escaping CompletionBlock)  {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestorAPI.apiInvestorAuthUpdateTokenGet(authorization: token) { (token, error) in
            guard token != nil else {
                return ErrorHandler.handleApiError(error: error, completion: completion)
            }
            
            AuthManager.authorizedToken = token
            completion(.success)
        }
    }
}
