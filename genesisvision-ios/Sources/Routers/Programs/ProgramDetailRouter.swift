//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramDetailRouteType {
    case invest(investmentProgramId: String), withdraw(investmentProgramId: String), history(investmentProgramId: String), requests(investmentProgramId: String)
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
        case .requests(let investmentProgramId):
            requests(with: investmentProgramId)
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
    
    private func requests(with investmentProgramId: String) {
        guard let viewController = ProgramRequestsViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramRequestsRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramRequestsViewModel(withRouter: router, investmentProgramId: investmentProgramId, delegate: viewController)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

