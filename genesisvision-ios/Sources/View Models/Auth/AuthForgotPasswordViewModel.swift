//
//  AuthForgetPasswordViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class AuthForgetPasswordViewModel {
    
    // MARK: - Variables
    var title: String = "Forgot password"
    let successText = String.Info.forgotPasswordSuccess
    private var router: ForgotPasswordRouter!
    
    // MARK: - Init
    init(withRouter router: ForgotPasswordRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func showForgotPasswordInfoVC() {
        router.show(routeType: .forgotPasswordInfo)
    }
    
    func goToBack() {
        router.goToBack(animated: true)
    }
    
    // MARK: - API
    func forgotPassword(email: String, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        AuthDataProvider.forgotPassword(email: email, captchaCheckResult: captchaCheckResult, completion: completion)
    }
    
    func riskControl(email: String, completion: @escaping CompletionBlock) {
        BaseDataProvider.riskControl(with: email, version: getFullVersion(), completion: { [weak self] (model) in
            guard let model = model, let captchaType = model.captchaType else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            switch captchaType {
            case .pow:
                guard let powId = model.id?.uuidString, let pow = model.pow, let nonce = pow.nonce, let difficulty = pow.difficulty else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                captcha_hash(email, nonce: nonce, difficulty: difficulty, completion: { (result) in
                    let powResult = PowResult(_prefix: result)
                    let captchaCheckResult = CaptchaCheckResult(id: powId.lowercased(), pow: powResult, geeTest: nil)
                    self?.forgotPassword(email: email, captchaCheckResult: captchaCheckResult, completion: completion)
                })
            default:
                self?.forgotPassword(email: email, completion: completion)
            }
            }, errorCompletion: completion)
    }
}

