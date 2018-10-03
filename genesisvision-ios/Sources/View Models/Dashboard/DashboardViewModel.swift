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
    
    var highToLowValue: Bool = false
    
    var router: DashboardRouter!
    var dashboard: DashboardSummary? {
        didSet {
            guard let dashboard = dashboard else { return }
            
            if let vc = router.chartsViewController, let pageboyDataSource = vc.pageboyDataSource {
                pageboyDataSource.update(dashboardPortfolioChartValue: dashboard.chart, dashboardRequests: dashboard.requests)
            }
            if let vc = router.assetsViewController, let pageboyDataSource = vc.pageboyDataSource {
                pageboyDataSource.update(dashboardSummary: dashboard)
            }
            if let vc = router.eventsViewController, let viewModel = vc.viewModel {
                viewModel.dashboardPortfolioEvents = dashboard.events
            }
            assetsTabmanViewModel?.dashboard = dashboard
            chartsTabmanViewModel?.dashboardPortfolioChartValue = dashboard.chart
            eventListViewModel?.dashboardPortfolioEvents = dashboard.events
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
        self.inRequestsDelegateManager.inRequestsDelegate = router.dashboardViewController
        
        assetsTabmanViewModel = AssetsTabmanViewModel(withRouter: router, tabmanViewModelDelegate: nil, dashboard: dashboard)
        chartsTabmanViewModel = ChartsTabmanViewModel(withRouter: router, tabmanViewModelDelegate: nil, dashboardPortfolioChartValue: dashboard?.chart)
        eventListViewModel = EventListViewModel(withRouter: router, dashboardPortfolioEvents: dashboard?.events)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableTwoFactorNotification(notification:)), name: .twoFactorEnable, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .twoFactorEnable, object: nil)
    }
    
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
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (viewModel) in
            self?.updateFetchedData(viewModel)
            }, completionError: completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion: completion)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(_ dashboard: DashboardSummary) {
        self.dashboard = dashboard
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ viewModel: DashboardSummary) -> Void, completionError: @escaping CompletionBlock) {
        let type: InvestorAPI.ModelType_v10InvestorGet = .all
        let assetType: InvestorAPI.AssetType_v10InvestorGet = .all
        let skip = 0
        let take = Constants.Api.take
        let chartCurrency = InvestorAPI.ChartCurrency_v10InvestorGet(rawValue: getSelectedCurrency())
        
        DashboardDataProvider.getDashboardSummary(with: nil, from: dateRangeFrom, to: dateRangeTo, type: type, assetType: assetType, skip: skip, take: take, chartCurrency: chartCurrency, chartFrom: dateRangeFrom, chartTo: dateRangeTo, requestsSkip: skip, requestsTake: take, completion: { (dashboard) in
//        DashboardDataProvider.getDashboardSummary(completion: { (dashboard) in
            guard let dashboard = dashboard else { return completionError(.failure(errorType: .apiError(message: nil))) }
            completionSuccess(dashboard)
            completionError(.success)
        }, errorCompletion: completionError)
    }
}

extension DashboardViewModel: ReloadDataProtocol {
    func didReloadData() {
        refresh { (result) in }
    }
}

protocol SortingDelegate: class {
    func didSelectSorting(at indexPath: IndexPath)
}

final class SortingDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var tableViewProtocol: SortingDelegate?
    
    // MARK: - Variables
    var highToLowValue: Bool = true
    
    var sorting: InvestorAPI.Sorting_v10InvestorProgramsGet = Constants.Sorting.dashboardDefault
    
    var sortingDescKeys: [InvestorAPI.Sorting_v10InvestorProgramsGet] = [.byProfitDesc,
                                                                      .byLevelDesc,
                                                                      .byBalanceDesc,
                                                                      .byTradesDesc,
                                                                      .byEndOfPeriodDesc,
                                                                      .byTitleDesc]
    
    var sortingAscKeys: [InvestorAPI.Sorting_v10InvestorProgramsGet] = [.byProfitAsc,
                                                                      .byLevelAsc,
                                                                      .byBalanceAsc,
                                                                      .byTradesAsc,
                                                                      .byEndOfPeriodAsc,
                                                                      .byTitleAsc]
    
    var sortingValues: [String] = ["profit",
                                   "level",
                                   "balance",
                                   "orders",
                                   "end of period",
                                   "title"]
    
    struct SortingList {
        var sortingValue: String
        var sortingKey: InvestorAPI.Sorting_v10InvestorProgramsGet
    }
    
    var sortingDescList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingDescKeys[index])
        }
    }
    
    var sortingAscList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingAscKeys[index])
        }
    }
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    // MARK: - Private methods
    func getSortingValue(sortingKey: InvestorAPI.Sorting_v10InvestorProgramsGet) -> String {
        guard let index = sortingDescKeys.index(of: sortingKey) else { return "" }
        return sortingValues[index]
    }
    
    func changeSorting(at index: Int) {
        sorting = highToLowValue ? sortingDescKeys[index] : sortingAscKeys[index]
    }
    
    func getSelectedSortingIndex() -> Int {
        return sortingDescKeys.index(of: sorting) ?? 0
    }
    
    func sortTitle() -> String? {
        return "Sort by " + getSortingValue(sortingKey: sorting)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        changeSorting(at: indexPath.row)
        
        tableViewProtocol?.didSelectSorting(at: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sortingValues[indexPath.row]
        cell.backgroundColor = UIColor.Cell.bg
        
        cell.textLabel?.textColor = indexPath.row == getSelectedSortingIndex() ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        cell.accessoryType = indexPath.row == getSelectedSortingIndex() ? .checkmark : .none
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath), cell.accessoryType == .none {
            cell.textLabel?.textColor = UIColor.Cell.title
            cell.contentView.backgroundColor = UIColor.Cell.title.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath), cell.accessoryType == .none {
            cell.textLabel?.textColor = UIColor.Cell.subtitle
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}

protocol CurrencyDelegateManagerProtocol: class {
    func didSelectCurrency(at indexPath: IndexPath)
}

final class CurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var currencyDelegate: CurrencyDelegateManagerProtocol?
    
    var currencyValues: [String] = ["USD", "EUR", "BTC"]
    var rateValues: [Double] = [6.3, 5.5, 0.0002918]
    
    var selectedCurrency: String!
    
    var currencyCellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        selectedCurrency = getSelectedCurrency()
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCurrency = currencyValues[indexPath.row]
        updateSelectedCurrency(selectedCurrency)
        
        currencyDelegate?.didSelectCurrency(at: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCurrencyTableViewCell", for: indexPath) as? DashboardCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let currency = currencyValues[indexPath.row]
        let rate = "1 GVT = \(rateValues[indexPath.row]) " + currency
        let isSelected = currency == selectedCurrency
        
        cell.isSelected = isSelected
        cell.configure(title: currency, rate: rate, selected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath) as? DashboardCurrencyTableViewCell, cell.accessoryType == .none {
            cell.currencyTitleLabel.textColor = UIColor.Cell.title
            cell.currencyRateLabel.textColor = UIColor.Cell.title
            cell.contentView.backgroundColor = UIColor.Cell.title.withAlphaComponent(0.3)
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath) as? DashboardCurrencyTableViewCell, cell.accessoryType == .none {
            cell.currencyTitleLabel.textColor = UIColor.Cell.subtitle
            cell.currencyRateLabel.textColor = UIColor.Cell.subtitle
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}

protocol InRequestsDelegateManagerProtocol: class {
    func didTapDeleteButton(at indexPath: IndexPath)
}

final class InRequestsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var inRequestsDelegate: InRequestsDelegateManagerProtocol?
    
    var inRequestsCellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardInRequestsTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInRequestsTableViewCell", for: indexPath) as? DashboardInRequestsTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cancelRowAction = UITableViewRowAction(style: .normal, title: "Cancel") { [weak self] (action, indexPath) in
            self?.inRequestsDelegate?.didTapDeleteButton(at: indexPath)
            //TODO: or cancel this
        }
        cancelRowAction.backgroundColor = UIColor.Cell.redTitle
        
        return [cancelRowAction]
    }
}
