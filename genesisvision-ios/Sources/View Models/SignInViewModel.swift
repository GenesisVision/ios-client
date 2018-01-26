//
//  SignInViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class SignInViewModel {
    
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
    func signIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        isInvestorApp
            ? investorSignIn(email: email, password: password, completion: completion)
            : managerSignIn(email: email, password: password, completion: completion)
    }
    
    
    // MARK: - Private methods
    // MARK: - API
    private func investorSignIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        
        InvestorAPI.apiInvestorAuthSignInPostWithRequestBuilder(model: loginViewModel).execute { [weak self] (response, error) in
            self?.signInResponseHandler(response, error: error, completion: completion)
        }
    }
    
    private func managerSignIn(email: String, password: String, completion: @escaping ApiCompletionBlock) {
        let loginViewModel = LoginViewModel(email: email, password: password)
        
        ManagerAPI.apiManagerAuthSignInPostWithRequestBuilder(model: loginViewModel).execute { [weak self] (response, error) in
            self?.signInResponseHandler(response, error: error, completion: completion)
        }
    }
    
    private func signInResponseHandler(_ response: Response<String>?, error: Error?, completion: @escaping ApiCompletionBlock) {
        guard response != nil && response?.statusCode == 200 else {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        //save token
        if let token = response?.body {
            AuthManager.authorizedToken = token
        }
        
        completion(ApiCompletionResult.success)
    }
}
