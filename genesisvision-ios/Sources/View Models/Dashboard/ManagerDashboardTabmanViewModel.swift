//
//  ManagerDashboardTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 27/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Tabman

final class ManagerDashboardTabmanViewModel: TabmanViewModel {
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
    }
    
    // MARK: - Private methods
    func setup() {
        self.items = []
        if let router = router as? ManagerDashboardTabmanRouter {
            if let vc = router.getDashboard() {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            reloadPages()
        }
    }
    
    // MARK: - Public methods
    func showCreateProgramVC() {
        router.showCreateProgramVC()
    }
}

