//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum DashboardRouteType {
    case showProgramDetail(investmentProgramID: String)
}

class DashboardRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
        switch routeType {
        case .showProgramDetail(let investmentProgramID):
            showProgramDetail(with: investmentProgramID)
        }
    }
    
    // MARK: - Private methods
    func getDetailViewController(with investmentProgramID: String, state: ProgramDetailViewState) -> ProgramDetailViewController? {
        guard let traderViewController = ProgramDetailViewController.storyboardInstance(name: .traders) else { return nil }
        let router = ProgramDetailRouter(parentRouter: self)
        let viewModel = ProgramDetailViewModel(withRouter: router, with: investmentProgramID, state: state)
        traderViewController.viewModel = viewModel
        
        return traderViewController
    }
    
    private func showProgramDetail(with investmentProgramID: String) {
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramDetailRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailViewModel(withRouter: router, with: investmentProgramID, state: .full)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
