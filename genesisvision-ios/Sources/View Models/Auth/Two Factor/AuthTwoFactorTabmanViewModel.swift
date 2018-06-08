//
//  AuthTwoFactorTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 31/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class AuthTwoFactorTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var sharedKey: String?
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Enable Two Factor"
        isProgressive = true
        isScrollEnabled = false
    }
    
    override func initializeViewControllers() {
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        if let router = router as? AuthTwoFactorTabmanRouter {
            if let vc = router.getTutorialVC(with: self) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let vc = router.getCreateVC(with: self) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let vc = router.getConfirmationVC(with: self) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            reloadPages()
        }
    }
}

