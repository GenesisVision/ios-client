//
//  TournamentRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum TournamentRouterType {
    case showDetail(participantViewModel: ParticipantViewModel), getDetail(participantViewModel: ParticipantViewModel)
}

class TournamentRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: TournamentRouterType) {
        switch routeType {
        case .getDetail(let participantViewModel):
            getDetail(with: participantViewModel)
        case .showDetail(let participantViewModel):
            showDetail(with: participantViewModel)
        }
    }
    
    func getDetail(with participantViewModel: ParticipantViewModel) -> TournamentDetailViewController? {
        guard let viewController = TournamentDetailViewController.storyboardInstance(name: .traders) else { return nil }
        let router = TournamentDetailRouter(parentRouter: self)
        let viewModel = TournamentDetailViewModel(withRouter: router, with: participantViewModel)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Private methods
    private func showDetail(with participantViewModel: ParticipantViewModel) {
        guard let viewController = TournamentDetailViewController.storyboardInstance(name: .traders) else { return }
        let router = TournamentDetailRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = TournamentDetailViewModel(withRouter: router, with: participantViewModel)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

