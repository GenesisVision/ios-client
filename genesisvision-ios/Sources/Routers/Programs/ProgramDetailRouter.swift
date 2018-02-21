//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramDetailRouteType {
    case invest(investmentProgramId: String), withdraw(investmentProgramId: String), history(investmentProgramId: String)
}

class ProgramDetailRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDetailRouteType) {
        switch routeType {
        case .invest(let investmentProgramId):
            invest(with: investmentProgramId)
        case .withdraw(let investmentProgramId):
            withdraw(with: investmentProgramId)
        case .history(let investmentProgramId):
            history(with: investmentProgramId)
        }
    }
    
    // MARK: - Private methods
    private func invest(with investmentProgramId: String) {
        guard let viewController = ProgramInvestViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramInvestRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramInvestViewModel(withRouter: router, investmentProgramId: investmentProgramId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func withdraw(with investmentProgramId: String) {
        guard let viewController = ProgramWithdrawViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramWithdrawRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, investmentProgramId: investmentProgramId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func history(with investmentProgramId: String) {
        guard let viewController = ProgramHistoryViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramHistoryRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramHistoryViewModel(withRouter: router, investmentProgramId: investmentProgramId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

