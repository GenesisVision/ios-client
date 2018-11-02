//
//  AuthChangePasswordViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class AuthChangePasswordViewModel {
    
    // MARK: - Variables
    var title: String = "Change password"
    
    private var router: ChangePasswordRouter!
    let text = "Password successfully changed"
    
    // MARK: - Init
    init(withRouter router: ChangePasswordRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func showChangePasswordInfoVC() {
        router.show(routeType: .changePasswordInfo)
    }
    
    // MARK: - API
    func changePassword(oldPassword: String, password: String, confirmPassword: String, completion: @escaping CompletionBlock) {
        AuthDataProvider.changePassword(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword, completion: { (token) in
            AuthManager.authorizedToken = token
            completion(.success)
        }, errorCompletion: completion)
    }
}


