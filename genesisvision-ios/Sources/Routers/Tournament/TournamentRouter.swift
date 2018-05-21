//
//  TournamentRouter.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum TournamentRouteType {
    
}

class TournamentRouter: TabmanRouter {
    
    // MARK: - Public methods
    func getTournamentVC(roundNumber: Int) -> TournamentListViewController? {
        guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return nil }
        let tournamentListRouter = TournamentListRouter(parentRouter: self)
        let viewModel = TournamentListViewModel(withRouter: tournamentListRouter, reloadDataProtocol: viewController, roundNumber: roundNumber)
        viewController.viewModel = viewModel
        return viewController
    }
}

