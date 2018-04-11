//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramDetailRouteType {
    case invest(investmentProgramId: String, currency: String), withdraw(investmentProgramId: String, investedTokens: Double, currency: String), history(investmentProgramId: String), requests(investmentProgramId: String), description(investmentProgramDetails: InvestmentProgramDetails), trades(investmentProgramId: String)
}

class ProgramDetailRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDetailRouteType) {
        switch routeType {
        case .invest(let investmentProgramId, let currency):
            invest(with: investmentProgramId, currency: currency)
        case .withdraw(let investmentProgramId, let investedTokens, let currency):
            withdraw(with: investmentProgramId, investedTokens: investedTokens, currency: currency)
        case .history(let investmentProgramId):
            history(with: investmentProgramId)
        case .requests(let investmentProgramId):
            requests(with: investmentProgramId)
        case .description(let investmentProgramDetails):
            description(with: investmentProgramDetails)
        case .trades(let investmentProgramId):
            trades(with: investmentProgramId)
        }
    }
    
    // MARK: - Private methods
    private func history(with investmentProgramId: String) {
        guard let viewController = ProgramHistoryViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramHistoryRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramHistoryViewModel(withRouter: router, investmentProgramId: investmentProgramId, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func description(with investmentProgramDetails: InvestmentProgramDetails) {
        guard let viewController = ProgramDescriptionViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramDescriptionRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDescriptionViewModel(withRouter: router, investmentProgramDetails: investmentProgramDetails)
        viewController.viewModel = viewModel

        guard let topViewController = navigationController?.topViewController else {
            return
        }
        
        present(viewController: viewController, from: topViewController)
    }
    
    private func requests(with investmentProgramId: String) {
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramRequestsViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramRequestsRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramRequestsViewModel(withRouter: router, investmentProgramId: investmentProgramId, programDetailProtocol: vc as! ProgramDetailProtocol, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func trades(with investmentProgramId: String) {
        guard let viewController = ProgramDetailTradesViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramDetailTradesRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailTradesViewModel(withRouter: router, investmentProgramId: investmentProgramId, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

