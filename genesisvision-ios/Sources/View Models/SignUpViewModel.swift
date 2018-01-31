//
//  SignUpViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class SignUpViewModel {
    
    // MARK: - Variables
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
    func signUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        isInvestorApp
            ? investorSignUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
            : managerSignUp(email: email, password: password, confirmPassword: confirmPassword, completion: completion)
    }
    
    // MARK: - Private methods
    // MARK: - API Methods
    private func investorSignUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        InvestorAPI.apiInvestorAuthSignUpPost(model: registerInvestorViewModel) { [weak self] (error) in
            self?.responseHandler(error: error, completion: completion)
        }
    }
    
    private func managerSignUp(email: String, password: String, confirmPassword: String, completion: @escaping ApiCompletionBlock) {
        let registerManagerViewModel = RegisterManagerViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        ManagerAPI.apiManagerAuthSignUpPost(model: registerManagerViewModel) { [weak self] (error) in
            self?.responseHandler(error: error, completion: completion)
        }
    }
    
    private func responseHandler(error: Error?, completion: @escaping ApiCompletionBlock) {
        error == nil
            ? completion(ApiCompletionResult.success)
            : ErrorHandler.handleApiError(error: error, completion: completion)
    }
}
