//
//  AccountProfitViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.20.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class AccountProfitViewModel: ViewModelWithListProtocol, ViewModelWithFilter {
    var canPullToRefresh: Bool = true
    
    var viewModels: [CellViewAnyModel] = []
    
    enum SectionType {
        case chart
        case statistics
    }
    
    // MARK: - Variables
    var title: String = "Profit"
    var assetId: String?
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var chartViewProtocol: ChartViewProtocol?
    
    var dataType: DataType = .api
    
    var dateFrom: Date?
    var dateTo: Date?
    var maxPointCount: Int = ApiKeys.maxPoint
    private var currency: CurrencyType?
    private var accountProfitChart: AccountProfitPercentCharts?
    
    private var sections: [SectionType] = [.chart, .statistics]
    
    private var accountProfitChartTableViewCellViewModel:  AccountProfitChartTableViewCellViewModel?
    private var accountProfitStatisticTableViewCellViewModel: AccountProfitStatisticTableViewCellViewModel?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String, reloadDataProtocol: ReloadDataProtocol?, currency: CurrencyType?) {
        self.router = router
        self.assetId = assetId
        self.currency = currency
        self.reloadDataProtocol = reloadDataProtocol
        self.chartViewProtocol = router.currentController as? ChartViewProtocol
    }
    
    // MARK: - Public methods
    func selectSimpleChartPoint(_ date: Date) {
    }
}

// MARK: - TableView
extension AccountProfitViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AccountProfitChartTableViewCellViewModel.self, AccountProfitStatisticTableViewCellViewModel.self]
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return 20.0
        }
    }
}

// MARK: - Fetch
extension AccountProfitViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard let accountProfitChart = accountProfitChart else { return nil }
        
        switch sections[indexPath.section] {
        case .chart:
            self.accountProfitChartTableViewCellViewModel = AccountProfitChartTableViewCellViewModel(accountProfitChart: accountProfitChart, chartViewProtocol: self.chartViewProtocol)
            return accountProfitChartTableViewCellViewModel
        case .statistics:
            if let statistic = accountProfitChart.statistic, let currency = currency {
                self.accountProfitStatisticTableViewCellViewModel = AccountProfitStatisticTableViewCellViewModel(currency: currency, statistic: statistic)
                return accountProfitStatisticTableViewCellViewModel
            }
        }
        
        return nil
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }

        AccountsDataProvider.getProfitPercentCharts(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currencyType: getPlatformCurrencyType(), currencies: [selectedPlatformCurrency], completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return ErrorHandler.handleApiError(error: nil, completion: completion)
            }
            
            self?.accountProfitChart = viewModel
            self?.reloadDataProtocol?.didReloadData()
            completion(.success)
            }, errorCompletion: completion)
    }
}
