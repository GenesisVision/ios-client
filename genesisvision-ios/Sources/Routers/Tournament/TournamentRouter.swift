//
//  TournamentRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum TournamentRouteType {
    case showDetail(participantId: String), getDetail(participantId: String)
}

class TournamentRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: TournamentRouteType) {
        switch routeType {
        case .getDetail(let participantId):
            _ = getDetail(with: participantId)
        case .showDetail(let participantId):
            showDetail(with: participantId)
        }
    }
    
    func getDetail(with participantId: String) -> TournamentDetailViewController? {
        guard let viewController = TournamentDetailViewController.storyboardInstance(name: .tournament) else { return nil }
        let router = TournamentDetailRouter(parentRouter: self)
        let viewModel = TournamentDetailViewModel(withRouter: router, with: participantId)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Private methods
    private func showDetail(with participantId: String) {
        guard let viewController = TournamentDetailViewController.storyboardInstance(name: .tournament) else { return }
        let router = TournamentDetailRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = TournamentDetailViewModel(withRouter: router, with: participantId)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

