//
//  InvestmentProgramListRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramRouteType {
    case signIn, showProgramDetails(investmentProgramId: String), showFilterVC(investmentProgramListViewModel: InvestmentProgramListViewModel), showTournamentVC(tournamentTotalRounds: Int, tournamentCurrentRound: Int)
}

class InvestmentProgramListRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ProgramRouteType) {
        switch routeType {
        case .signIn:
            signInAction()
        case .showFilterVC(let investmentProgramListViewModel):
            showFilterVC(with: investmentProgramListViewModel)
        case .showProgramDetails(let investmentProgramId):
            showProgramDetails(with: investmentProgramId)
        case .showTournamentVC(let tournamentTotalRounds, let tournamentCurrentRound):
            showTournamentVC(tournamentTotalRounds: tournamentTotalRounds, tournamentCurrentRound: tournamentCurrentRound)
        }
    }
    
    // MARK: - Private methods
    private func signInAction() {
        guard let viewController = SignInViewController.storyboardInstance(name: .auth) else { return }
        let router = SignInRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = AuthSignInViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showFilterVC(with investmentProgramListViewModel: InvestmentProgramListViewModel) {
        guard let viewController = ProgramFilterViewController.storyboardInstance(name: .programs) else { return }
        let router = ProgramFilterRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramFilterViewModel(withRouter: router, investmentProgramListViewModel: investmentProgramListViewModel)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showTournamentVC(tournamentTotalRounds: Int, tournamentCurrentRound: Int) {
        guard let tabmanViewController = TournamentTabmanViewController.storyboardInstance(name: .tournament), tournamentCurrentRound > 0 else { return }
        let router = TournamentRouter(parentRouter: self)
        let viewModel = TournamentViewModel(withRouter: router, viewControllersCount: tournamentTotalRounds, defaultPage: tournamentCurrentRound - 1, tabmanViewModelDelegate: tabmanViewController)
        tabmanViewController.viewModel = viewModel
        tabmanViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tabmanViewController, animated: true)
    }
}
