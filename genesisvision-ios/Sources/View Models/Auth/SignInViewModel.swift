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
    
    func showForgotPasswordVC() {
        router.show(routeType: .forgotPassword)
    }
    
    // MARK: - API
    func signIn(email: String, password: String, completion: @escaping CompletionBlock) {
        AuthDataProvider.signIn(email: email, password: password, completion: { (token) in
            AuthManager.authorizedToken = token
            completion(.success)
        }) { (result) in
            completion(result)
        }
    }
}
