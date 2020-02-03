//
//  AuthTwoFactorConfirmationViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

protocol AuthTwoFactorConfirmationViewModel {
    var isEnable: Bool { get }
    var title: String { get }
    var buttonTitleText: String { get }
    var numbersLimit: Int { get }
    var router: TabmanRouter! { get }
    
    func confirm(twoFactorCode: String?, recoveryCode: String?, password: String, completion: @escaping (_ recoveryCodes: [String]?) -> Void, errorCompletion: @escaping CompletionBlock)
    func showSuccess(recoveryCodes: [String]?)
}

extension AuthTwoFactorConfirmationViewModel {
    func showSuccess(recoveryCodes: [String]? = nil) {
        
    }
}

final class AuthTwoFactorEnableConfirmationViewModel: AuthTwoFactorConfirmationViewModel {
    var isEnable: Bool = true
    
    // MARK: - Variables
    public private(set) var title: String = "Verify"
    public private(set) var buttonTitleText: String = "Confirm"
    public private(set) var numbersLimit: Int = 6
    
    private var tabmanViewModel: AuthTwoFactorTabmanViewModel!
    internal var router: TabmanRouter!
    
    // MARK: - Init
    init(withRouter router: TabmanRouter, tabmanViewModel: AuthTwoFactorTabmanViewModel) {
        self.router = router
        self.tabmanViewModel = tabmanViewModel
    }
    
    // MARK: - Public methods
    func confirm(twoFactorCode: String?, recoveryCode: String? = nil, password: String, completion: @escaping (_ recoveryCodes: [String]?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let sharedKey = tabmanViewModel.sharedKey, let twoFactorCode = twoFactorCode else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        TwoFactorDataProvider.confirm(twoFactorCode: twoFactorCode, sharedKey: sharedKey, password: password, completion: { (viewModel) in
            guard let codes = viewModel?.codes else { return completion(nil) }
            if let newToken = viewModel?.authToken {
                AuthManager.authorizedToken = newToken
            }
            let recoveryCodes: [String] = codes.map({ return $0.code ?? "" })
            
            completion(recoveryCodes)
        }, errorCompletion: errorCompletion)
    }
    
    // MARK: - Navigation
    func showSuccess(recoveryCodes: [String]? = nil) {
        NotificationCenter.default.post(name: .twoFactorChange, object: nil, userInfo: ["enable" : true])
        
        guard let recoveryCodes = recoveryCodes, let router = router as? AuthTwoFactorTabmanRouter else { return }
        router.show(routeType: .successEnable(recoveryCodes))
    }
}
