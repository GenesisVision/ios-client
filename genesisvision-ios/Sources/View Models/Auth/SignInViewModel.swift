//
//  SignInViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class SignInViewModel {
    
    // MARK: - Variables
    var title: String = "Sign In"
    
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
    
    // MARK: - API
    func signIn(email: String, password: String, completion: @escaping CompletionBlock) {
        isInvestorApp
            ? investorSignIn(email: email, password: password, completion: completion)
            : managerSignIn(email: email, password: password, completion: completion)
    }
    
    
    // MARK: - Private methods
    // MARK: - API
    private func investorSignIn(email: String, password: String, completion: @escaping CompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        InvestorAPI.apiInvestorAuthSignInPost(model: loginViewModel) { [weak self] (token, error) in
            self?.responseHandler(token, error: error, completion: completion)
        }
    }
    
    private func managerSignIn(email: String, password: String, completion: @escaping CompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        ManagerAPI.apiManagerAuthSignInPost(model: loginViewModel) { [weak self] (token, error) in
            self?.responseHandler(token, error: error, completion: completion)
        }
    }
    
    private func responseHandler(_ token: String?, error: Error?, completion: @escaping CompletionBlock) {
        guard token != nil else {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        AuthManager.authorizedToken = token
        
        completion(.success)
    }
}
