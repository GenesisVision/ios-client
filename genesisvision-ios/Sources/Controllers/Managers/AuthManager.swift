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
            guard let token = UserDefaults.standard.string(forKey: UserDefaultKeys.authorizedToken) else { return nil }
            
            return "Bearer " + token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.authorizedToken)
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
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.authorizedToken)
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.biometricEnable)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.biometricLastDomainState)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.passcode)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.passcodeEnable)
        
        UserDefaults.standard.synchronize()
    }
    
    static func getSavedRates(completion: @escaping (_ rates: [RateItem]?) -> Void) {
        getRates { (viewModel) in
            guard let viewModel = viewModel else { return completion(nil) }
            completion(viewModel.rates?.GVT)
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
    
    static func twoFactorEnabled(completion: @escaping (Bool) -> Void) {
        getTwoFactorStatus(completion: { (model) in
            completion(model.twoFactorEnabled ?? false)
        }) { (result) in
            switch result {
            case .success:
                completion(false)
                break
            case .failure(let errorType):
                completion(false)
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    static func getRates(completion: @escaping (_ rate: RatesModel?) -> Void) {
        guard ratesModel == nil else {
            completion(ratesModel)
            return
        }
        
        RateDataProvider.getRates(completion: { (viewModel) in
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
        
        WalletDataProvider.get(with: currency, completion: { (viewModel) in
            if viewModel != nil  {
                walletViewModel = viewModel
            }
            
            completion(walletViewModel)
        }, errorCompletion: completionError)
    }
    
    static func getTwoFactorStatus(completion: @escaping (_ twoFactorStatus: TwoFactorStatus) -> Void, completionError: @escaping CompletionBlock) {
        if let twoFactorStatus = twoFactorStatus {
            completion(twoFactorStatus)
        }
        
        TwoFactorDataProvider.auth2faGetStatus(completion: { (viewModel) in
            guard let viewModel = viewModel else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            twoFactorStatus = viewModel
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
