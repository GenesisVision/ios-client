//
//  TournamentViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class TournamentViewModel: TabmanViewModel {
    // MARK: - Init
    override init(withRouter router: Router, viewControllersCount: Int = 1, defaultPage: Int = 1, tabmanViewModelDelegate: TabmanViewModelDelegate?) {
        super.init(withRouter: router, viewControllersCount: viewControllersCount, defaultPage: defaultPage, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Tournament"
    }
    
    func setup() {
        for idx in 1...viewControllersCount {
            if let router = router as? TournamentRouter, let vc = router.getTournamentVC(roundNumber: idx) {
                self.addItem("Round \(idx)")
                self.addController(vc)
            }
        }
        
        reloadPages()
    }
    
    override func initializeViewControllers() {
        setup()
    }
}
