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
    private static var walletViewModel: WalletSummary?
    private static var ratesModel: RatesModel?
    private static var twoFactorStatus: TwoFactorStatus?
    
    static var authorizedToken: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizedToken) else { return nil }
            
            return "Bearer " + token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.authorizedToken)
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
        AuthManager.resetUserDefaults()
        AuthManager.authorizedToken = nil
        AuthManager.profileViewModel = nil
        AuthManager.walletViewModel = nil
        AuthManager.ratesModel = nil
    }
    
    static func isLogin() -> Bool {
        return AuthManager.authorizedToken != nil
    }
    
    static func resetUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.authorizedToken)
        
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.biometricEnable)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.biometricLastDomainState)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.passcode)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.passcodeEnable)
        
        UserDefaults.standard.synchronize()
    }
    
    static func getSavedRate(completion: @escaping (_ rate: Double) -> Void) {
        getRate { (viewModel) in
            completion(ratesModel?.rates?.GVT?.first?.rate ?? 0.0)
        }
    }
    
    static func getBalance(completion: @escaping (_ balance: Double) -> Void, completionError: @escaping CompletionBlock) {
        getWallet(completion: { (viewModel) in
            completion(walletViewModel?.availableGVT?.rounded(withType: .gvt) ?? 0.0)
        }, completionError: completionError)
    }
    
    static func saveWalletViewModel(viewModel: WalletSummary) {
        self.walletViewModel = viewModel
    }
    
    static func saveProfileViewModel(viewModel: ProfileFullViewModel) {
        self.profileViewModel = viewModel
    }
    
    static func saveTwoFactorStatus(viewModel: TwoFactorStatus) {
        self.twoFactorStatus = viewModel
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
    
    static func getRate(completion: @escaping (_ rate: RatesModel?) -> Void) {
        guard ratesModel == nil else {
            completion(ratesModel)
            return
        }
        
        RateDataProvider.getRate(completion: { (viewModel) in
            if viewModel != nil  {
                ratesModel = viewModel
            }
            
            completion(ratesModel)
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    static func getWallet(completion: @escaping (_ wallet: WalletSummary?) -> Void, completionError: @escaping CompletionBlock) {
        if let walletViewModel = walletViewModel {
            completion(walletViewModel)
        }
        
        let currency: WalletAPI.Currency_v10WalletByCurrencyGet = .gvt
        
        WalletDataProvider.getWallet(with: currency, completion: { (viewModel) in
            if viewModel != nil  {
                walletViewModel = viewModel
            }
            
            completion(walletViewModel)
        }, errorCompletion: completionError)
    }
    
    static func getTwoFactorStatus(completion: @escaping (_ twoFactorStatus: TwoFactorStatus?) -> Void, completionError: @escaping CompletionBlock) {
        if let twoFactorStatus = twoFactorStatus {
            completion(twoFactorStatus)
        }
        
        TwoFactorDataProvider.auth2faGetStatus(completion: { (viewModel) in
            if viewModel != nil  {
                twoFactorStatus = viewModel
            }
            
            completion(viewModel)
        }, errorCompletion: completionError)
    }
    
    // MARK: - Private methods
    private func updateApiToken(completion: @escaping CompletionBlock)  {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        AuthAPI.v10AuthTokenUpdatePost(authorization: token) { (token, error) in
            guard token != nil else {
                return ErrorHandler.handleApiError(error: error, completion: completion)
            }
            
            AuthManager.authorizedToken = token
            completion(.success)
        }
    }
}
