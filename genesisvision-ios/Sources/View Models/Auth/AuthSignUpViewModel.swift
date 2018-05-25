//
//  AuthSignUpViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class AuthSignUpViewModel {
    
    // MARK: - Variables
    var title: String = "Sign Up"
    
    private var router: SignUpRouter!
    
    // MARK: - Init
    init(withRouter router: SignUpRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func showConfirmationVC() {
        router.show(routeType: .confirmation)
    }
    
    // MARK: - API
    func signUp(email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        AuthDataProvider.signUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
}
