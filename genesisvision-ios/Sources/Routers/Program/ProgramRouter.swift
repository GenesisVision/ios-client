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
    var programBalanceViewController: BalanceViewController?
    var programProfitViewController: ProfitViewController?
    
    // MARK: - Public methods
    func getInfo(with assetId: String) -> ProgramInfoViewController? {
        let viewController = ProgramInfoViewController()
        
        let router = ProgramInfoRouter(parentRouter: self)
        router.programViewController = programViewController
        router.currentController = viewController
        let viewModel = ProgramInfoViewModel(withRouter: router, assetId: assetId, delegate: viewController)
        viewModel.programHeaderProtocol = viewController
        viewModel.assetType = assetType 
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        programInfoViewController = viewController
        return viewController
    }
    
    func getTrades(with assetId: String, currencyType: CurrencyType) -> TradesViewController? {

        let viewController = TradesViewController()
        let viewModel = ProgramTradesViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, currencyType: currencyType)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getTradesOpen(with assetId: String, currencyType: CurrencyType) -> TradesViewController? {

        let viewController = TradesViewController()
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
    
    func getPeriodHistory(with assetId: String, currency: Currency) -> ProgramPeriodHistoryViewController? {
        
        let viewController = ProgramPeriodHistoryViewController()
        let viewModel = ProgramPeriodHistoryViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: viewController, currency: currency)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getEvents(with assetId: String) -> EventListViewControllerWithSections? {
        guard let viewController = getEventsViewController(with: assetId, router: self, allowsSelection: false, assetType: .program) else { return nil }
        
        return viewController
    }
    
}
