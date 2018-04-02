//
//  ForgetPasswordViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ForgetPasswordViewModel {
    
    // MARK: - Variables
    var title: String = "Forgot Password?"
    
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

