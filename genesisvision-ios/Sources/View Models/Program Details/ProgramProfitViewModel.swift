//
//  ProgramProfitViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ProgramProfitViewModel: ViewModelWithListProtocol, ViewModelWithFilter {
    var canPullToRefresh: Bool = true
    
    var viewModels: [CellViewAnyModel] = []
    
    enum SectionType {
        case chart
        case statistics
    }
    
    // MARK: - Variables
    var title: String = "Profit"
    var assetId: String?
    var assetType: AssetType
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var chartViewProtocol: ChartViewProtocol?
    
    var dataType: DataType = .api
    
    var dateFrom: Date?
    var dateTo: Date?
    var maxPointCount: Int = ApiKeys.maxPoint
    private var currency: CurrencyType?
    private var programProfitChart: ProgramProfitPercentCharts? {
        didSet {
            if let router = router as? ProgramRouter {
                chartViewProtocol = router.programProfitViewController
            }
        }
    }
    
    private var followProfitChar: AbsoluteProfitChart? {
        didSet {
            if let router = router as? ProgramRouter {
                chartViewProtocol = router.programProfitViewController
            }
        }
    }
    
    private var statistics: ProgramChartStatistic?
    
    private var sections: [SectionType] = [.chart, .statistics]
    
    private var programProfitChartTableViewCellViewModel:  ProgramProfitChartTableViewCellViewModel?
    private var programProfitStatisticTableViewCellViewModel: ProgramProfitStatisticTableViewCellViewModel?
    private let programType: BrokerTradeServerType
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String, reloadDataProtocol: ReloadDataProtocol?, currency: CurrencyType?, programType: BrokerTradeServerType? = nil, assetType: AssetType) {
        self.router = router
        self.assetId = assetId
        self.currency = currency
        self.reloadDataProtocol = reloadDataProtocol
        self.programType = programType ?? .undefined
        self.assetType = assetType
    }
    
    // MARK: - Public methods
    func selectSimpleChartPoint(_ date: Date) {
    }
}

// MARK: - TableView
extension ProgramProfitViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramProfitChartTableViewCellViewModel.self, ProgramProfitStatisticTableViewCellViewModel.self]
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
extension ProgramProfitViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        switch sections[indexPath.section] {
        case .chart:
            switch assetType {
            case .program:
                self.programProfitChartTableViewCellViewModel = ProgramProfitChartTableViewCellViewModel(programProfitChart: programProfitChart, followProfitChart: followProfitChar, chartViewProtocol: self.chartViewProtocol)
                return programProfitChartTableViewCellViewModel
            case .follow:
                self.programProfitChartTableViewCellViewModel = ProgramProfitChartTableViewCellViewModel(programProfitChart: programProfitChart, followProfitChart: followProfitChar, chartViewProtocol: self.chartViewProtocol)
                return programProfitChartTableViewCellViewModel
            default:
                break
            }

        case .statistics:
            if let statistic = statistics, let currency = currency {
                self.programProfitStatisticTableViewCellViewModel = ProgramProfitStatisticTableViewCellViewModel(currency: currency, statistic: statistic, programType: programType)
                return programProfitStatisticTableViewCellViewModel
            }
        }
        
        return nil
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = assetId,
              let currency = Currency(rawValue: selectedPlatformCurrency) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        switch assetType {
        case .follow:
            FollowsDataProvider.getAbsoluteProfitChart(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.followProfitChar = viewModel
                self?.reloadDataProtocol?.didReloadData()
                completion(.success)
                }, errorCompletion: completion)
            
            FollowsDataProvider.getProfitPercentCharts(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: getPlatformCurrencyType(), currencies: [currency], completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                self?.statistics = viewModel?.statistic
                self?.reloadDataProtocol?.didReloadData()
                completion(.success)
                }, errorCompletion: completion)
        case .program:
            ProgramsDataProvider.getProfitPercentCharts(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: getPlatformCurrencyType(), currencies: [currency], completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.programProfitChart = viewModel
                self?.statistics = viewModel?.statistic
                self?.reloadDataProtocol?.didReloadData()
                completion(.success)
                }, errorCompletion: completion)
        default:
            break
        }
    }
}
