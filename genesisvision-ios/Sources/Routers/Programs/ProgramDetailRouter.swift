//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramDetailRouteType {
    case invest(investmentProgramId: String), withdraw(investmentProgramId: String, investedTokens: Double), history(investmentProgramId: String), requests(investmentProgramId: String), description(investmentProgramDetails: InvestmentProgramDetails)
}

class ProgramDetailRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDetailRouteType) {
        switch routeType {
        case .invest(let investmentProgramId):
            invest(with: investmentProgramId)
        case .withdraw(let investmentProgramId, let investedTokens):
            withdraw(with: investmentProgramId, investedTokens: investedTokens)
        case .history(let investmentProgramId):
            history(with: investmentProgramId)
        case .requests(let investmentProgramId):
            requests(with: investmentProgramId)
        case .description(let investmentProgramDetails):
            description(with: investmentProgramDetails)
        }
    }
    
    // MARK: - Private methods
    private func history(with investmentProgramId: String) {
        guard let viewController = ProgramHistoryViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramHistoryRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramHistoryViewModel(withRouter: router, investmentProgramId: investmentProgramId)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func description(with investmentProgramDetails: InvestmentProgramDetails) {
        guard let viewController = ProgramDescriptionViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramDescriptionRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDescriptionViewModel(withRouter: router, investmentProgramDetails: investmentProgramDetails)
        viewController.viewModel = viewModel
        let navController = BaseNavigationController(rootViewController: viewController)

        guard let topViewController = navigationController?.topViewController else {
            return
        }
        
        present(viewController: navController, from: topViewController)
    }
    
    private func requests(with investmentProgramId: String) {
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramRequestsViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramRequestsRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramRequestsViewModel(withRouter: router, investmentProgramId: investmentProgramId, programDetailProtocol: vc as! ProgramDetailProtocol)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

