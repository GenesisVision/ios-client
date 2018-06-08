//
//  ProgramDetailsRouter.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramDetailsRouter: TabmanRouter {
    // MARK: - Variables
    var programDetailViewController: ProgramDetailViewController?
    
    // MARK: - Public methods
    func getDetail(with investmentProgramDetails: InvestmentProgramDetails) -> ProgramDetailViewController? {
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .program) else { return nil }
        
        let router = ProgramDetailRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramDetailViewModel(withRouter: router, investmentProgramDetails: investmentProgramDetails, reloadDataProtocol: viewController, detailChartTableViewCellProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        programDetailViewController = viewController
        return viewController
    }
    
    func getDescription(with investmentProgramDetails: InvestmentProgramDetails) -> ProgramDescriptionViewController? {
        guard let viewController = ProgramDescriptionViewController.storyboardInstance(name: .program) else { return  nil }
        
        let router = ProgramDescriptionRouter(parentRouter: self)
        let viewModel = ProgramDescriptionViewModel(withRouter: router, investmentProgramDetails: investmentProgramDetails)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getTrades(with investmentProgramId: String) -> ProgramDetailTradesViewController? {
        let viewController = ProgramDetailTradesViewController()
        let router = ProgramDetailTradesRouter(parentRouter: self)
        let viewModel = ProgramDetailTradesViewModel(withRouter: router, investmentProgramId: investmentProgramId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getHistory(with investmentProgramId: String) -> ProgramHistoryViewController? {
        let viewController = ProgramHistoryViewController()
        let router = ProgramHistoryRouter(parentRouter: self)
        let viewModel = ProgramHistoryViewModel(withRouter: router, investmentProgramId: investmentProgramId, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getRequests(with investmentProgramId: String) -> ProgramRequestsViewController? {
        guard let vc = currentController as? ProgramDetailsTabmanViewController else { return nil }
        
        let viewController = ProgramRequestsViewController()
        let router = ProgramRequestsRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramRequestsViewModel(withRouter: router, investmentProgramId: investmentProgramId, programDetailProtocol: vc, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getFullChart(with investmentProgramDetails: InvestmentProgramDetails) -> ProgramDetailFullChartViewController? {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(name: .program) else { return nil }
        
        let router = ProgramDetailFullChartRouter(parentRouter: self)
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, investmentProgramDetails: investmentProgramDetails)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve
        
        return viewController
    }
}
