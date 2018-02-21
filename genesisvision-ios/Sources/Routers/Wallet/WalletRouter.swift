//
//  WalletRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WalletRouteType {
    case withdraw, deposit, showProgramDetail(investmentProgram: InvestmentProgram, state: ProgramDetailViewState)
}

class WalletRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WalletRouteType) {
        switch routeType {
        case .withdraw:
            withdraw()
        case .deposit:
            deposit()
        case .showProgramDetail(let investmentProgram, let state):
            showProgramDetail(with: investmentProgram, state: state)
        }
    }
    
    // MARK: - Private methods
    private func withdraw() {
        //TODO: withdraw
    }
    
    private func deposit() {
        //TODO: deposit
    }
    
    private func showProgramDetail(with investmentProgram: InvestmentProgram, state: ProgramDetailViewState) {
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramDetailRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailViewModel(withRouter: router, with: investmentProgram, state: state)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
