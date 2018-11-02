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
    let text = "We sent a verification link to the email you specified. \nPlease follow this link to complete the registration."
    
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
    
    // MARK: - API
    func signUp(username: String, email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        AuthDataProvider.signUp(username: username, email: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
}
