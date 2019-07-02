//
//  AuthSignUpViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class AuthSignUpViewModel {
    
    // MARK: - Variables
    var title: String = "Sign up"
    
    private var router: SignUpRouter!
    let successText = String.Info.signUpConfirmationSuccess
    
    // MARK: - Init
    init(withRouter router: SignUpRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func showConfirmationVC() {
        router.show(routeType: .confirmation)
    }
    
    func showPrivacy() {
        router.show(routeType: .privacy)
    }
    
    func showTerms() {
        router.show(routeType: .terms)
    }
    
    func goToBack() {
        router.goToBack(animated: true)
    }
    
    // MARK: - API
    func signUp(username: String, email: String, password: String, confirmPassword: String, captchaCheckResult: CaptchaCheckResult? = nil, completion: @escaping CompletionBlock) {
        AuthDataProvider.signUp(username: username, email: email, password: password, confirmPassword: confirmPassword, captchaCheckResult: captchaCheckResult, completion: completion)
    }
    
    func riskControl(username: String, email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        BaseDataProvider.riskControl(with: email, version: getFullVersion(), completion: { [weak self] (model) in
            guard let model = model, let captchaType = model.captchaType else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            switch captchaType {
            case .pow:
                guard let powId = model.id?.uuidString, let pow = model.pow, let nonce = pow.nonce, let difficulty = pow.difficulty else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                captcha_hash(email, nonce: nonce, difficulty: difficulty, completion: { (result) in
                    let powResult = PowResult(_prefix: result)
                    let captchaCheckResult = CaptchaCheckResult(id: powId.lowercased(), pow: powResult, geeTest: nil)
                    self?.signUp(username: username, email: email, password: password, confirmPassword: confirmPassword, captchaCheckResult: captchaCheckResult, completion: completion)
                })
            default:
                self?.signUp(username: username, email: email, password: password, confirmPassword: confirmPassword, completion: completion)
            }
        }, errorCompletion: completion)
    }
}
