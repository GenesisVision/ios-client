//
//  ProgramProfitViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ProgramProfitViewModel {
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
    var programCurrency: CurrencyType?
    private var programProfitChart: ProgramProfitPercentCharts?
    
    private var sections: [SectionType] = [.chart, .statistics]
    
    private var programProfitChartTableViewCellViewModel:  ProgramProfitChartTableViewCellViewModel?
    private var programProfitStatisticTableViewCellViewModel: ProgramProfitStatisticTableViewCellViewModel?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.assetId = assetId
        self.reloadDataProtocol = reloadDataProtocol
        self.chartViewProtocol = router.currentController as? ChartViewProtocol
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
    
    func heightForHeader(in section: Int) -> CGFloat {
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
    func model(for section: Int) -> CellViewAnyModel? {
        guard let programProfitChart = programProfitChart else { return nil }
        
        switch sections[section] {
        case .chart:
            self.programProfitChartTableViewCellViewModel = ProgramProfitChartTableViewCellViewModel(programProfitChart: programProfitChart, chartViewProtocol: self.chartViewProtocol)
            return programProfitChartTableViewCellViewModel
        case .statistics:
            if let statistic = programProfitChart.statistic {
                self.programProfitStatisticTableViewCellViewModel = ProgramProfitStatisticTableViewCellViewModel(currency: programCurrency!, statistic: statistic)
                return programProfitStatisticTableViewCellViewModel
            }
        }
        
        return nil
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
            ProgramsDataProvider.getProfitPercentCharts(with: assetId, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.programProfitChart = viewModel
                self?.reloadDataProtocol?.didReloadData()
                completion(.success)
                }, errorCompletion: completion)
        case .fake:
            break
        }
    }
}
