//
//  WelcomeViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import StoreKit

final class WelcomeViewModel {
    
    // MARK: - Variables
    var title: String = ""
    
    private var router: WelcomeRouter!
    
    // MARK: - Init
    init(withRouter router: WelcomeRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func start() {
        
        if isUITest {
            AuthManager.signOut()
        }
        
        requestReview()
        AuthManager.isLogin()
            ? startAsAuthorized()
            : startAsUnauthorized()
    }
    
    // MARK: - Private methods
    private func startAsAuthorized() {
        router.show(routeType: .startAsAuthorized)
    }
    
    private func startAsUnauthorized() {
        router.show(routeType: .startAsUnauthorized)
    }
    
    private func requestReview() {
        guard !isDebug else { return }
        
        let key = UserDefaultKeys.timesOpened
        var timesOpened = UserDefaults.standard.integer(forKey: key)
        
        timesOpened += 1
        UserDefaults.standard.set(timesOpened, forKey: key)
        
        if timesOpened > 29 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
        }
        
    }
}
