//
//  ProgramDetailsRouter.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramDetailsRouter: TabmanRouter {
    // MARK: - Variables
    var programInfoViewController: ProgramInfoViewController?
    
    // MARK: - Public methods
    func getInfo(with programDetailsFull: ProgramDetailsFull) -> ProgramInfoViewController? {
        let viewController = ProgramInfoViewController()
        
        let router = ProgramInfoRouter(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramInfoViewModel(withRouter: router, programDetailsFull: programDetailsFull, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        programInfoViewController = viewController
        return viewController
    }
    
    func getTrades(with programId: String) -> ProgramDetailTradesViewController? {
        let viewController = ProgramDetailTradesViewController()
        let router = ProgramDetailTradesRouter(parentRouter: self)
        let viewModel = ProgramDetailTradesViewModel(withRouter: router, programId: programId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getEvents(with programId: String) -> ProgramHistoryViewController? {
        let viewController = ProgramHistoryViewController()
        let router = ProgramHistoryRouter(parentRouter: self)
        let viewModel = ProgramHistoryViewModel(withRouter: router, programId: programId, reloadDataProtocol: viewController as? ReloadDataProtocol)
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
        let router = Router(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramBalanceViewModel(withRouter: router, programId: programId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with programId: String) -> ProgramProfitViewController? {
        guard let vc = currentController as? ProgramDetailsTabmanViewController else { return nil }
        
        let viewController = ProgramProfitViewController()
        let router = Router(parentRouter: self)
        router.currentController = viewController
        let viewModel = ProgramProfitViewModel(withRouter: router, programId: programId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
