//
//  FundProfitViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class FundProfitViewModel {
    enum SectionType {
        case chart
        case statistics
    }
    
    // MARK: - Variables
    var title: String = "Profit".uppercased()
    var fundId: String?
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var chartViewProtocol: ChartViewProtocol?
    
    var dataType: DataType = .api
    
    private var fundProfitChart: FundProfitChart?
    
    private var sections: [SectionType] = [.chart, .statistics]
    
    private var fundProfitChartTableViewCellViewModel:  FundProfitChartTableViewCellViewModel?
    private var fundProfitStatisticTableViewCellViewModel: FundProfitStatisticTableViewCellViewModel?
    
    // MARK: - Init
    init(withRouter router: Router, fundId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.fundId = fundId
        self.reloadDataProtocol = reloadDataProtocol
        self.chartViewProtocol = router.currentController as? ChartViewProtocol
    }
    
    // MARK: - Public methods
    func selectChartSimple(_ date: Date) {
        if let result = fundProfitChart?.equityChart?.first(where: { $0.date == date }) {
            print("selectChartSimple")
            print(result)
        }
    }
}

// MARK: - TableView
extension FundProfitViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundProfitChartTableViewCellViewModel.self, FundProfitStatisticTableViewCellViewModel.self]
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
extension FundProfitViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for section: Int) -> CellViewAnyModel? {
        guard let fundProfitChart = fundProfitChart else { return nil }
        
        switch sections[section] {
        case .chart:
            self.fundProfitChartTableViewCellViewModel = FundProfitChartTableViewCellViewModel(fundProfitChart: fundProfitChart, chartViewProtocol: self.chartViewProtocol)
            return fundProfitChartTableViewCellViewModel
        case .statistics:
            self.fundProfitStatisticTableViewCellViewModel = FundProfitStatisticTableViewCellViewModel(fundProfitChart: fundProfitChart)
            return fundProfitStatisticTableViewCellViewModel
        }
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let fundId = fundId else { return completion(.failure(errorType: .apiError(message: nil))) }
            FundsDataProvider.getProfitChart(with: fundId, completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.fundProfitChart = viewModel
                
                completion(.success)
                }, errorCompletion: completion)
        case .fake:
            break
        }
    }
}
