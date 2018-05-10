//
//  TournamentViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class TournamentViewModel: TabmanViewModel {
    // MARK: - Init
    override init(withRouter router: Router) {
        super.init(withRouter: router)
        
        title = "Tournament"
    }
    
    override func initializeViewControllers() {
        for idx in 1...4 {
            guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return }
            let router = TournamentRouter(parentRouter: self.router)
            let viewModel = TournamentListViewModel(withRouter: router, reloadDataProtocol: viewController, roundNumber: idx)
            viewController.viewModel = viewModel
            itemTitles.append("Round \(idx)")
            viewControllers.append(viewController)
        }
    }
}
