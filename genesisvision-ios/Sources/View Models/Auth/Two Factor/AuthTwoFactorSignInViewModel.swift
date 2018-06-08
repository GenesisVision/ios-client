//
//  AuthTwoFactorSignInViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class AuthTwoFactorSignInViewModel {
    // MARK: - Variables
    var title: String = "Two Factor Authentication"
    
    var buttonTitle: String = "Sign In"
    var titleText: String = String.ViewTitles.TwoFactor.signInTitle
    var labelPlaceholder: String = ""

    private var email: String
    private var password: String
    public private(set) var numbersLimit: Int = 6
    private var router: AuthTwoFactorSignInRouter!
    
    // MARK: - Init
    init(withRouter router: AuthTwoFactorSignInRouter, email: String, password: String) {
        self.router = router
        self.email = email
        self.password = password
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func startAsAuthorized() {
        router.show(routeType: .startAsAuthorized)
    }
    
    // MARK: - API
    func signIn(twoFactorCode: String? = nil, recoveryCode: String? = nil, completion: @escaping CompletionBlock) {
        AuthDataProvider.signIn(email: email, password: password, twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, completion: { (token) in
            AuthManager.authorizedToken = token
            completion(.success)
        }) { (result) in
            completion(result)
        }
    }
}
