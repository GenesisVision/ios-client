//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum DashboardRouteType {
    case showAssetDetails(assetId: String, assetType: AssetType)
    case assetList, notificationList, allEvents, requests(programRequests: ProgramRequests?), eventDetails(event: InvestmentEventViewModel)
    case showFilterVC(listViewModel: ListViewModelProtocol, filterModel: FilterModel, filterType: FilterType, sortingType: SortingType)
}

class DashboardRouter: Router, SignalRouterProtocol, ListRouterProtocol {
    
    var dashboardViewController: DashboardViewController!
    
    var chartsViewController: ChartsViewController?
    var eventsViewController: EventsViewController?
    var dashboardAssetsViewController: AssetsViewController?
    
    var programListViewController: DashboardProgramListViewController?
    var fundListViewController: DashboardFundListViewController?
    
    var signalListViewController: SignalListViewController?
    var signalOpenTradesViewController: SignalOpenTradesViewController?
    var signalTradesViewController: SignalTradesViewController?
    var signalTradingLogViewController: SignalTradingLogViewController?
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, dashboardViewController: DashboardViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.dashboardViewController = dashboardViewController
    }

    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
        switch routeType {
        case .showAssetDetails(let assetId, let assetType):
            showAssetDetails(with: assetId, assetType: assetType)
        case .assetList:
            showAssetList()
        case .notificationList:
            showNotificationList()
        case .allEvents:
            showEvents()
        case .requests(let programRequests):
            showRequests(programRequests)
        case .eventDetails(let event):
            showEventDetails(event)
        case .showFilterVC(let listViewModel, let filterModel, let filterType, let sortingType):
            showFilterVC(with: listViewModel, filterModel: filterModel, filterType: filterType, sortingType: sortingType)
        }
    }
    
    // MARK: - Private methods
    private func showAssetList() {
        changeTab(withParentRouter: self, to: .assetList)
    }
    
    private func showRequests(_ programRequests: ProgramRequests?) {
        dashboardViewController.showRequests(programRequests)
    }
    
    private func showEventDetails(_ event: InvestmentEventViewModel) {
        dashboardViewController.showDetails(event)
    }
}
