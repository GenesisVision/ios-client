//
//  AuthTwoFactorTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 31/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Tabman

final class AuthTwoFactorTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var sharedKey: String?
    
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Enable Two Factor"
        isProgressive = true
        isScrollEnabled = false
        bounces = false
        compresses = true
    }
    
    override func initializeViewControllers() {
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        self.items = []
        
        if let router = router as? AuthTwoFactorTabmanRouter {
            if let vc = router.getTutorialVC(with: self) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getCreateVC(with: self) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getConfirmationVC(with: self) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            reloadPages()
        }
    }
}

