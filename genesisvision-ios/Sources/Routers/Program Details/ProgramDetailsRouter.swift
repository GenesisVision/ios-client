//
//  ProgramDetailsRouter.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramDetailsRouter: TabmanRouter {
    // MARK: - Variables
    var programDetailViewController: ProgramInfoViewController?
    
    // MARK: - Public methods
    func getDetail(with programDetailsFull: ProgramDetailsFull) -> ProgramInfoViewController? {
        guard let viewController = ProgramInfoViewController.storyboardInstance(name: .program) else { return nil }
        
        let router = ProgramDetailRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramInfoViewModel(withRouter: router, programDetailsFull: programDetailsFull, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        programDetailViewController = viewController
        return viewController
    }
    
    func getDescription(with programDetailsFull: ProgramDetailsFull) -> ProgramDescriptionViewController? {
        guard let viewController = ProgramDescriptionViewController.storyboardInstance(name: .program) else { return  nil }
        
        let router = ProgramDescriptionRouter(parentRouter: self)
        let viewModel = ProgramDescriptionViewModel(withRouter: router, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getTrades(with programId: String) -> ProgramDetailTradesViewController? {
        let viewController = ProgramDetailTradesViewController()
        let router = ProgramDetailTradesRouter(parentRouter: self)
        let viewModel = ProgramDetailTradesViewModel(withRouter: router, programId: programId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getHistory(with programId: String) -> ProgramHistoryViewController? {
        let viewController = ProgramHistoryViewController()
        let router = ProgramHistoryRouter(parentRouter: self)
        let viewModel = ProgramHistoryViewModel(withRouter: router, programId: programId, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getRequests(with programId: String) -> ProgramRequestsViewController? {
        let viewController = ProgramRequestsViewController()
        let router = ProgramRequestsRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramRequestsViewModel(withRouter: router, programId: programId, programDetailProtocol: nil, reloadDataProtocol: viewController as? ReloadDataProtocol)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getFullChart(with programDetailsFull: ProgramDetailsFull) -> ProgramDetailFullChartViewController? {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(name: .program) else { return nil }
        
        let router = ProgramDetailFullChartRouter(parentRouter: self)
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve
        
        return viewController
    }
    
    func getBalance(with programId: String) -> ProgramBalanceViewController? {
        guard let vc = currentController as? ProgramDetailsTabmanViewController else { return nil }
        
        let viewController = ProgramBalanceViewController()
        let router = ProgramHistoryRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramBalanceViewModel(withRouter: router, programId: programId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with programId: String) -> ProgramProfitViewController? {
        guard let vc = currentController as? ProgramDetailsTabmanViewController else { return nil }
        
        let viewController = ProgramProfitViewController()
        let router = ProgramHistoryRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramProfitViewModel(withRouter: router, programId: programId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
