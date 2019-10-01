//
//  DashboardTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 05/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Tabman

final class DashboardTabmanViewModel: TabmanViewModel {
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Dashboard"
    }
    
    // MARK: - Private methods
    func setup() {
        self.items = []
        if let router = router as? DashboardTabmanRouter {
            if let vc = router.getDashboard() {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
        
            reloadPages()
        }
    }
}
