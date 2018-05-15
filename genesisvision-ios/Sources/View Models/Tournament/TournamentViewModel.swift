//
//  TournamentViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class TournamentViewModel: TabmanViewModel {
    // MARK: - Init
    override init(withRouter router: Router, viewControllersCount: Int = 1, defaultPage: Int = 1) {
        super.init(withRouter: router, viewControllersCount: viewControllersCount, defaultPage: defaultPage)
        
        title = "Tournament"
    }
    
    override func initializeViewControllers() {
        for idx in 1...viewControllersCount {
            guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return }
            let tournamentRouter = TournamentRouter(parentRouter: self.router)
            let viewModel = TournamentListViewModel(withRouter: tournamentRouter, reloadDataProtocol: viewController, roundNumber: idx)
            viewController.viewModel = viewModel
            self.itemTitles.append("Round \(idx)")
            self.viewControllers.append(viewController)
        }
    }
}
