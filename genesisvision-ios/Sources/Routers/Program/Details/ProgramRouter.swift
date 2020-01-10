//
//  ProgramRouter.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramRouter: TabmanRouter {
    // MARK: - Variables
    var assetType: AssetType = .program
    var programViewController: ProgramViewController?
    var programInfoViewController: ProgramInfoViewController?
    var programBalanceViewController: ProgramBalanceViewController?
    var programProfitViewController: ProgramProfitViewController?
    
    // MARK: - Public methods
    func getInfo(with assetId: String) -> ProgramInfoViewController? {
        let viewController = ProgramInfoViewController()
        
        let router = ProgramInfoRouter(parentRouter: self)
        router.programViewController = programViewController
        router.currentController = viewController
        let viewModel = ProgramInfoViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: viewController)
        viewModel.programHeaderProtocol = viewController
        viewModel.assetType = assetType 
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        programInfoViewController = viewController
        return viewController
    }
    
    func getTrades(with assetId: String, currencyType: CurrencyType) -> ProgramTradesViewController? {

        let viewController = ProgramTradesViewController()
        let viewModel = ProgramTradesViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, currencyType: currencyType)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getTradesOpen(with assetId: String, currencyType: CurrencyType) -> ProgramTradesViewController? {

        let viewController = ProgramTradesViewController()
        let viewModel = ProgramTradesViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, isOpenTrades: true, currencyType: currencyType)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getFullChart(with programDetailsFull: ProgramFollowDetailsFull) -> ProgramDetailFullChartViewController? {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(.program) else { return nil }
        
        let viewModel = ProgramDetailFullChartViewModel(withRouter: self, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve
        
        return viewController
    }
    
    func getBalance(with assetId: String) -> ProgramBalanceViewController? {
        guard let vc = currentController as? ProgramViewController else { return nil }
        
        let viewController = ProgramBalanceViewController()
        let viewModel = ProgramBalanceViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getPeriodHistory(with assetId: String, currency: CurrencyType) -> ProgramPeriodHistoryViewController? {
        
        let viewController = ProgramPeriodHistoryViewController()
        let viewModel = ProgramPeriodHistoryViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, currency: currency)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with assetId: String) -> ProgramProfitViewController? {
        guard let vc = currentController as? ProgramViewController else { return nil }
        
        let viewController = ProgramProfitViewController()
        let viewModel = ProgramProfitViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getEvents(with assetId: String) -> EventListViewController? {
        guard let viewController = getEventsViewController(with: assetId, router: self, allowsSelection: true, assetType: .program) else { return nil }
        
        return viewController
    }
    
}
