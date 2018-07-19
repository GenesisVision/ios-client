//
//  DashboardTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 05/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class DashboardTabmanViewModel: TabmanViewModel {
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Dashboard"
    }
    
    // MARK: - Private methods
    func setup() {
        if let router = router as? DashboardTabmanRouter {
            if let vc = router.getDashboard() {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let vc = router.getFavorites() {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            reloadPages()
        }
    }
    
    // MARK: - Public methods
    func showCreateProgramVC() {
        router.showCreateProgramVC()
    }
}
