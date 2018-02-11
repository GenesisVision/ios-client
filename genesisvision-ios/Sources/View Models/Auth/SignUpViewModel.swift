//
//  SignUpViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class SignUpViewModel {
    
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
        isInvestorApp
            ? investorSignUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
            : managerSignUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
    
    // MARK: - Private methods
    // MARK: - API Methods
    private func investorSignUp(email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        InvestorAPI.apiInvestorAuthSignUpPost(model: registerInvestorViewModel) { (error) in
            ResponseHandler.handleApi(error: error, completion: completion)
        }
    }
    
    private func managerSignUp(email: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        let registerManagerViewModel = RegisterManagerViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        ManagerAPI.apiManagerAuthSignUpPost(model: registerManagerViewModel) { (error) in
            ResponseHandler.handleApi(error: error, completion: completion)
        }
    }
}
