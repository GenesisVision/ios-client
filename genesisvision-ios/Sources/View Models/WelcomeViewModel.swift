//
//  WelcomeViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import StoreKit

class WelcomeViewModel {
    
    // MARK: - Variables
    var title: String = "Invest"
    
    private var router: WelcomeRouter!
    
    // MARK: - Init
    init(withRouter router: WelcomeRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func start() {
        requestReview()
        isTournamentApp
            ? startTournament()
            : AuthManager.isLogin()
                ? startAsAuthorized()
                : startAsUnauthorized()
    }
    
    // MARK: - Private methods
    
    private func startAsAuthorized() {
        AuthManager.updateToken()
        router.show(routeType: .startAsAuthorized)
    }
    
    private func startAsUnauthorized() {
        router.show(routeType: .startAsUnauthorized)
    }
    
    private func startTournament() {
        router.show(routeType: .startTournament)
    }
    
    private func requestReview() {
        let key = Constants.UserDefaults.timesOpened
        var timesOpened = UserDefaults.standard.integer(forKey: key)
        
        timesOpened += 1
        UserDefaults.standard.set(timesOpened, forKey: key)
        
        if timesOpened > 9 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
            UserDefaults.standard.removeObject(forKey: key)
        }
        
    }
}
