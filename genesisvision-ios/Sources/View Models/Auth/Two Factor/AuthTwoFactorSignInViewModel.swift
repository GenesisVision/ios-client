//
//  AuthTwoFactorSignInViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class AuthTwoFactorSignInViewModel {
    // MARK: - Variables
    var title: String = "Two factor authentication"
    
    var buttonTitle: String = "Sign in"
    var titleText: String = String.ViewTitles.TwoFactor.signInTitle
    var labelPlaceholder: String = ""

    private var email: String
    private var password: String
    public private(set) var numbersLimit: Int = 6
    private var router: AuthTwoFactorSignInRouter!
    
    // MARK: - Init
    init(withRouter router: AuthTwoFactorSignInRouter, email: String, password: String) {
        self.router = router
        self.email = email
        self.password = password
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func startAsAuthorized() {
        router.show(routeType: .startAsAuthorized)
    }
    
    // MARK: - API
    func signIn(twoFactorCode: String? = nil, recoveryCode: String? = nil, captchaResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        AuthDataProvider.signIn(email: email, password: password, twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, captchaCheckResult: captchaResult, completion: { (token) in
            AuthManager.authorizedToken = token
            completion(.success)
        }) { (result) in
            completion(result)
        }
    }
    
    func riskControl(twoFactorCode: String? = nil, recoveryCode: String? = nil, completion: @escaping CompletionBlock) {
        BaseDataProvider.riskControl(with: email, version: getFullVersion(), completion: { [weak self] (model) in
            guard let model = model, let captchaType = model.captchaType else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            switch captchaType {
            case .pow:
                guard let powId = model._id?.uuidString, let pow = model.pow, let nonce = pow.nonce, let difficulty = pow.difficulty else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                captcha_hash(self?.email ?? "", nonce: nonce, difficulty: difficulty, completion: { (result) in
                    let powResult = PowResult(_prefix: result)
                    let captchaCheckResult = CaptchaCheckResult(_id: powId.lowercased(), pow: powResult, geeTest: nil)
                    self?.signIn(twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, captchaResult: captchaCheckResult, completion: completion)
                })
            default:
                self?.signIn(twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, completion: completion)
            }
        }, errorCompletion: completion)
    }
}
