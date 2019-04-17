//
//  AuthSignInViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class AuthSignInViewModel {
    
    // MARK: - Variables
    var title: String = "Sign in"
    
    private var router: SignInRouter!
    
    // MARK: - Init
    init(withRouter router: SignInRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func startAsAuthorized() {
        router.show(routeType: .startAsAuthorized)
    }

    func showSignUpVC() {
        router.show(routeType: .signUp)
    }
    
    func showTwoFactorSignInVC(email: String, password: String) {
        router.show(routeType: .twoFactorSignIn(email: email, password: password))
    }
    
    func showForgotPasswordVC() {
        router.show(routeType: .forgotPassword)
    }
    
    // MARK: - API
    func signIn(email: String, password: String, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        AuthDataProvider.signIn(email: email, password: password, captchaCheckResult: captchaCheckResult, completion: { (token) in
            AuthManager.authorizedToken = token
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func riskControl(email: String, password: String, completion: @escaping CompletionBlock) {
        BaseDataProvider.riskControl(with: email, version: getFullVersion(), completion: { [weak self] (model) in
            guard let model = model, let captchaType = model.captchaType, let powId = model.id?.uuidString, let pow = model.pow, let nonce = pow.nonce, let difficulty = pow.difficulty else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            switch captchaType {
            case .pow:
                captcha_hash(email, nonce: nonce, difficulty: difficulty, completion: { (result) in
                    let powResult = PowResult(_prefix: result)
                    let captchaCheckResult = CaptchaCheckResult(id: powId, pow: powResult, geeTest: nil)
                    self?.signIn(email: email, password: password, captchaCheckResult: captchaCheckResult, completion: completion)
                })
            default:
                self?.signIn(email: email, password: password, completion: completion)
            }
        }, errorCompletion: completion)
    }
}
