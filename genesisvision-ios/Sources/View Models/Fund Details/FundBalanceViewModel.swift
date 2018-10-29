//
//  FundBalanceViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class FundBalanceViewModel {
    enum SectionType {
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Balance"
    var fundId: String?
    
    var router: FundRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var chartViewProtocol: ChartViewProtocol?
    
    var dataType: DataType = .api

    private var fundBalanceChart: FundBalanceChart?
    
    private var sections: [SectionType] = [.chart]
    
    private var fundBalanceChartTableViewCellViewModel:   ProgramBalanceChartTableViewCellViewModel?
    
    // MARK: - Init
    init(withRouter router: FundRouter, fundId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.fundId = fundId
        self.reloadDataProtocol = reloadDataProtocol
        self.chartViewProtocol = router.currentController as? ChartViewProtocol
    }
    
    // MARK: - Public methods
    func selectFundBalanceChartElement(_ date: Date) {
        if let result = fundBalanceChart?.balanceChart?.first(where: { $0.date == date }) {
            print("selectFundBalanceChartElement")
            print(result)
        }
    }
    
    func hideHeader(value: Bool = true) {
        router.fundViewController.hideHeader(value)
    }
}

// MARK: - TableView
extension FundBalanceViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundBalanceChartTableViewCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
}

// MARK: - Fetch
extension FundBalanceViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> FundBalanceChartTableViewCellViewModel? {
        guard let fundBalanceChart = fundBalanceChart else { return nil }
        
        let fundBalanceChartTableViewCellViewModel =  FundBalanceChartTableViewCellViewModel(fundBalanceChart: fundBalanceChart, chartViewProtocol: self.chartViewProtocol)
        
        return fundBalanceChartTableViewCellViewModel
    }
    
    // MARK: - Private methods
    private func fetch(_ completion: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let fundId = fundId else { return completion(.failure(errorType: .apiError(message: nil))) }
            FundsDataProvider.getBalanceChart(with: fundId, completion: { [weak self] (viewModel) in
                guard viewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completion)
                }
                
                self?.fundBalanceChart = viewModel
                
                completion(.success)
            }, errorCompletion: completion)
        case .fake:
            break
        }
    }
}
