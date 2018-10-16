//
//  DashboardViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class DashboardViewModel {
    // MARK: - Variables
    var title = "Dashboard"
    
    var sortingDelegateManager = SortingDelegateManager()
    var currencyDelegateManager = CurrencyDelegateManager()
    var inRequestsDelegateManager = InRequestsDelegateManager()
    var isLoading: Bool = false
    
    var highToLowValue: Bool = false
    
    var router: DashboardRouter!
    var dashboard: DashboardSummary? {
        didSet {
            guard let dashboard = dashboard else { return }
            
            if let vc = router.chartsViewController, let pageboyDataSource = vc.pageboyDataSource {
                pageboyDataSource.update(dashboardPortfolioChartValue: dashboard.chart, programRequests: dashboard.requests)
            }
            if let vc = router.assetsViewController, let pageboyDataSource = vc.pageboyDataSource {
                pageboyDataSource.update(dashboardSummary: dashboard)
            }
            if let vc = router.eventsViewController, let viewModel = vc.viewModel {
                viewModel.dashboardPortfolioEvents = dashboard.events
            }
        }
    }
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var assetsTabmanViewModel: AssetsTabmanViewModel?
    var chartsTabmanViewModel: ChartsTabmanViewModel?
    var eventListViewModel: EventListViewModel?
    
    var dateRangeType: DateRangeType = .day {
        didSet {
            switch dateRangeType {
            case .custom:
                dateRangeTo.setTime(hour: 0, min: 0, sec: 0)
                dateRangeFrom.setTime(hour: 23, min: 59, sec: 59)
            default:
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: dateRangeTo)
                let min = calendar.component(.minute, from: dateRangeTo)
                let sec = calendar.component(.second, from: dateRangeTo)
                dateRangeFrom.setTime(hour: hour, min: min, sec: sec)
            }
        }
    }
    
    var dateRangeFrom: Date = Date().previousDate()
    var dateRangeTo: Date = Date()
    
    var bottomViewType: BottomViewType {
        return .sort
    }
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        self.reloadDataProtocol = router.programListViewController

        assetsTabmanViewModel = AssetsTabmanViewModel(withRouter: router, tabmanViewModelDelegate: nil, dashboard: dashboard)
        chartsTabmanViewModel = ChartsTabmanViewModel(withRouter: router, tabmanViewModelDelegate: nil, dashboardPortfolioChartValue: dashboard?.chart)
        eventListViewModel = EventListViewModel(withRouter: router, dashboardPortfolioEvents: dashboard?.events)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableTwoFactorNotification(notification:)), name: .twoFactorEnable, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .twoFactorEnable, object: nil)
    }
    
    // MARK: - Public methods

    // MARK: - Private methods
    @objc private func enableTwoFactorNotification(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .twoFactorEnable, object: nil)
        
        router.showTwoFactorEnable()
    }
}

// MARK: - Navigation
extension DashboardViewModel {
    func logoImageName() -> String? {
        let imageName = "img_dashboard_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "you don’t have \nany programs yet.."
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse programs"
        return text.uppercased()
    }
    
    func showProgramList() {
        router.show(routeType: .programList)
    }
    
    func showNotificationList() {
        router.show(routeType: .notificationList)
    }
}

// MARK: - Fetch
extension DashboardViewModel {
    // MARK: - Public methods
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        isLoading = true
        
        let requestsSkip = 0
        let requestsTake = Constants.Api.take
        let chartCurrency = InvestorAPI.ChartCurrency_v10InvestorGet(rawValue: getSelectedCurrency())
        let balancePoints = 10
        let programsPoints = 5
        let eventsTake = 10
        
        DashboardDataProvider.getDashboardSummary(chartCurrency: chartCurrency, from: dateRangeFrom, to: dateRangeTo, balancePoints: balancePoints, programsPoints: programsPoints, eventsTake: eventsTake, requestsSkip: requestsSkip, requestsTake: requestsTake, completion: { [weak self] (dashboard) in
            guard let dashboard = dashboard else { return completion(.failure(errorType: .apiError(message: nil))) }
            self?.dashboard = dashboard
            
            completion(.success)
        }, errorCompletion: completion)
    }
}

extension DashboardViewModel: ReloadDataProtocol {
    func didReloadData() {
        refresh { (result) in }
    }
}

