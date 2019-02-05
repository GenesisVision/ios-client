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
    func signIn(email: String, password: String, completion: @escaping CompletionBlock) {
        AuthDataProvider.signIn(email: email, password: password, completion: { (token) in
            AuthManager.authorizedToken = token
            completion(.success)
        }, errorCompletion: completion)
    }
}
