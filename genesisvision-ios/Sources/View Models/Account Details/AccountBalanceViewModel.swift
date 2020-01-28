//
//  AccountBalanceViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.20.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class AccountBalanceViewModel: ViewModelWithListProtocol, ViewModelWithFilter {
    var canPullToRefresh: Bool = true
    var viewModels: [CellViewAnyModel] = []
    
    enum SectionType {
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Equity"
    var assetId: String?
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var chartViewProtocol: ChartViewProtocol?
    
    var dataType: DataType = .api

    var dateFrom: Date?
    var dateTo: Date?
    var maxPointCount: Int = ApiKeys.maxPoint
    
    private var accountBalanceChart: AccountBalanceChart?
    
    private var sections: [SectionType] = [.chart]
    
    private var accountBalanceChartTableViewCellViewModel: AccountBalanceChartTableViewCellViewModel?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.assetId = assetId
        self.reloadDataProtocol = reloadDataProtocol
        self.chartViewProtocol = router.currentController as? ChartViewProtocol
    }
}

// MARK: - TableView
extension AccountBalanceViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [AccountBalanceChartTableViewCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
}

// MARK: - Fetch
extension AccountBalanceViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard let accountBalanceChart = accountBalanceChart else { return nil }

        let accountBalanceChartTableViewCellViewModel =  AccountBalanceChartTableViewCellViewModel(accountBalanceChart: accountBalanceChart, currencyType: getPlatformCurrencyType(), chartViewProtocol: self.chartViewProtocol)

        return accountBalanceChartTableViewCellViewModel
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        AccountsDataProvider.getBalanceChart(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currencyType: getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return ErrorHandler.handleApiError(error: nil, completion: completion)
            }
            
            self?.accountBalanceChart = viewModel
            self?.reloadDataProtocol?.didReloadData()
            completion(.success)
        }, errorCompletion: completion)
    }
}
