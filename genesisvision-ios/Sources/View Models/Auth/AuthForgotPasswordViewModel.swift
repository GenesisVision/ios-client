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
    let text = "We sent a password reset link to the email you specified. \nPlease follow this link to reset your password."
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
    
    // MARK: - API
    func forgotPassword(email: String, completion: @escaping CompletionBlock) {
        AuthDataProvider.forgotPassword(email: email, completion: completion)
    }
}

