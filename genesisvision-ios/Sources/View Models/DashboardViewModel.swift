//
//  DashboardViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class DashboardViewModel {
    
    private var router: DashboardRouter!
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func invest() {
        router.show(routeType: .invest)
    }
}

