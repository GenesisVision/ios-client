//
//  ProgramTabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramTabmanRouter: TabmanRouter {
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
    
    func getTrades(with programId: String) -> ProgramTradesViewController? {
        guard let router = self.parentRouter as? ProgramRouter else { return nil }
        
        let viewController = ProgramTradesViewController()
        let viewModel = ProgramTradesViewModel(withRouter: router, programId: programId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getTradesOpen(with programId: String) -> ProgramTradesViewController? {
        guard let router = self.parentRouter as? ProgramRouter else { return nil }
        
        let viewController = ProgramTradesViewController()
        let viewModel = ProgramTradesViewModel(withRouter: router, programId: programId, reloadDataProtocol: viewController, isOpenTrades: true)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getFullChart(with programDetailsFull: ProgramDetailsFull) -> ProgramDetailFullChartViewController? {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(.program), let router = self.parentRouter as? ProgramRouter else { return nil }
        
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve
        
        return viewController
    }
    
    func getBalance(with programId: String) -> ProgramBalanceViewController? {
        guard let vc = currentController as? ProgramTabmanViewController, let router = self.parentRouter as? ProgramRouter else { return nil }
        
        let viewController = ProgramBalanceViewController()
        router.currentController = viewController
        let viewModel = ProgramBalanceViewModel(withRouter: router, programId: programId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with programId: String) -> ProgramProfitViewController? {
        guard let vc = currentController as? ProgramTabmanViewController, let router = self.parentRouter as? ProgramRouter else { return nil }
        
        let viewController = ProgramProfitViewController()
        router.currentController = viewController
        let viewModel = ProgramProfitViewModel(withRouter: router, programId: programId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getEvents(with assetId: String) -> AllEventsViewController? {
        guard let router = self.parentRouter as? ProgramRouter, let viewController = getEventsViewController(with: assetId, router: router, allowsSelection: false) else { return nil }
        
        return viewController
    }
    
}
