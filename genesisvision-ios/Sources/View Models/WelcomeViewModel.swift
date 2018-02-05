//
//  WelcomeViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

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
        AuthManager.isLogin()
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
}
