//
//  ProgramBalanceViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ProgramBalanceViewModel: ViewModelWithListProtocol, ViewModelWithFilter {
    var canPullToRefresh: Bool = true
    var viewModels: [CellViewAnyModel] = []
    
    enum SectionType {
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Equity"
    var assetId: String?
    var assetType: AssetType
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var chartViewProtocol: ChartViewProtocol?
    
    var dataType: DataType = .api

    var dateFrom: Date?
    var dateTo: Date?
    var maxPointCount: Int = ApiKeys.maxPoint
    
    private var programBalanceChart: ProgramBalanceChart? {
        didSet {
            guard let programBalanceChart = programBalanceChart else { return }
            
            if let router = router as? ProgramRouter {
                self.chartViewProtocol = router.programBalanceViewController
            }
            
            let programBalanceChartTableViewCellViewModel = ProgramBalanceChartTableViewCellViewModel(programBalanceChart: programBalanceChart, followBalanceChart: nil, chartViewProtocol: self.chartViewProtocol)
            
            viewModels = [programBalanceChartTableViewCellViewModel]
        }
    }
    
    private var followBalanceChart: AccountBalanceChart? {
        didSet {
            guard let followBalanceChart = followBalanceChart else { return }
            
            if let router = router as? ProgramRouter {
                self.chartViewProtocol = router.programBalanceViewController
            }
            
            let programBalanceChartTableViewCellViewModel = ProgramBalanceChartTableViewCellViewModel(programBalanceChart: nil, followBalanceChart: followBalanceChart, chartViewProtocol: self.chartViewProtocol)
            
            viewModels = [programBalanceChartTableViewCellViewModel]
        }
    }
    
    private var sections: [SectionType] = [.chart]
    
    private var programBalanceChartTableViewCellViewModel: ProgramBalanceChartTableViewCellViewModel?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String, reloadDataProtocol: ReloadDataProtocol?, assetType: AssetType) {
        self.router = router
        self.assetId = assetId
        self.reloadDataProtocol = reloadDataProtocol
        self.assetType = assetType
    }
}

// MARK: - TableView
extension ProgramBalanceViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramBalanceChartTableViewCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
}

// MARK: - Fetch
extension ProgramBalanceViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        
        if let programBalanceChart = programBalanceChart {
            return ProgramBalanceChartTableViewCellViewModel(programBalanceChart: programBalanceChart, followBalanceChart: nil, chartViewProtocol: self.chartViewProtocol)
        } else if let followBalanceChart = followBalanceChart {
            return ProgramBalanceChartTableViewCellViewModel(programBalanceChart: nil, followBalanceChart: followBalanceChart, chartViewProtocol: self.chartViewProtocol)
        } else {
            return nil
        }
        
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        switch assetType {
        case .follow:
            FollowsDataProvider.getBalanceChart(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.followBalanceChart = viewModel
                self?.reloadDataProtocol?.didReloadData()
                completion(.success)
            }, errorCompletion: completion)
        case .program:
            ProgramsDataProvider.getBalanceChart(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.programBalanceChart = viewModel
                self?.reloadDataProtocol?.didReloadData()
                completion(.success)
            }, errorCompletion: completion)
        default:
            break
        }
    }
}
