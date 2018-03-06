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
            case .failure(let reason):
                print("Token not updated")
                print(reason ?? "Fail with no reason")
            }
        }
    }
    
    static func isLogin() -> Bool {
        return AuthManager.authorizedToken != nil
    }
    
    static func getSavedRate(completion: @escaping (_ rate: Double) -> Void) {
        getRate { (viewModel) in
            completion(rateViewModel?.rate ?? 0.0)
        }
    }
    
    static func getBalance(completion: @escaping (_ balance: Double) -> Void) {
        getWallet { (viewModel) in
            completion(walletViewModel?.amount?.rounded(toPlaces: 4) ?? 0.0)
        }
    }
    
    static func saveWalletViewModel(viewModel: WalletViewModel) {
        self.walletViewModel = viewModel
    }
    
    static func getProfile(completion: @escaping (_ profile: ProfileFullViewModel?) -> Void) {
        guard profileViewModel != nil else {
            ProfileDataProvider.getProfileFull(completion: { (viewModel) in
                if viewModel != nil  {
                    profileViewModel = viewModel
                }
                
                completion(viewModel)
            })
            return
        }
        
        completion(profileViewModel)
    }
    
    static func getRate(completion: @escaping (_ rate: RateViewModel?) -> Void) {
        guard rateViewModel != nil else {
            RateDataProvider.getTake(completion: { (viewModel) in
                if viewModel != nil  {
                    rateViewModel = viewModel
                }
                
                completion(rateViewModel)
            })
            return
        }
        
        completion(rateViewModel)
    }
    
    static func getWallet(completion: @escaping (_ wallet: WalletViewModel?) -> Void) {
        guard walletViewModel != nil else {
            WalletDataProvider.getWallet(completion: { (viewModel) in
                if viewModel != nil  {
                    walletViewModel = viewModel?.wallets?.first
                }
                
                completion(walletViewModel)
            })
            return
        }
        
        completion(walletViewModel)
    }
    
    // MARK: - Private methods
    private func updateApiToken(completion: @escaping CompletionBlock)  {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        InvestorAPI.apiInvestorAuthUpdateTokenGet(authorization: token) { (token, error) in
            guard token != nil else {
                return ErrorHandler.handleApiError(error: error, completion: completion)
            }
            
            AuthManager.authorizedToken = token
            completion(.success)
        }
    }
}
