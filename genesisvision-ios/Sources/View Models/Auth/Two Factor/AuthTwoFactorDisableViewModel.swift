//
//  AuthTwoFactorDisableViewModel.swift
//  genesisvision-ios
//
//  Created by George on 04/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class AuthTwoFactorDisableConfirmationViewModel: AuthTwoFactorConfirmationViewModel {
    var isEnable: Bool = false
    
    // MARK: - Variables
    var title: String = "Disable"
    var buttonTitleText: String = "Disable"
    public private(set) var numbersLimit: Int = 6
    
    internal var router: TabmanRouter!
    
    // MARK: - Init
    init(withRouter router: TabmanRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    func confirm(twoFactorCode: String?, recoveryCode: String?, password: String, completion: @escaping (_ recoveryCodes: [String]?) -> Void, errorCompletion: @escaping CompletionBlock) {

        TwoFactorDataProvider.disable(twoFactorCode: twoFactorCode, recoveryCode: recoveryCode, password: password) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(_):
                errorCompletion(result)
            }
        }
    }
    
    func confirm(twoFactorCode: String, password: String, completion: @escaping CompletionBlock) {
        TwoFactorDataProvider.disable(twoFactorCode: twoFactorCode, password: password, completion: completion)
    }
    
    // MARK: - Navigation
    func showSuccess(recoveryCodes: [String]? = nil) {
        NotificationCenter.default.post(name: .twoFactorChange, object: nil, userInfo: ["enable" : false])
        
        guard let router = router as? AuthTwoFactorDisableRouter else { return }
        router.show(routeType: .successDisable)
    }
}
