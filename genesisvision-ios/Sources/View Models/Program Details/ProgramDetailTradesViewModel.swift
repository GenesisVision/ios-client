//
//  ProgramDetailTradesViewModel.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ProgramDetailTradesViewModel {
    // MARK: - Variables
    var title: String = "Trades"
    var investmentProgramId: String?
    
    var router: ProgramDetailTradesRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var transactionsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var tradeServerType: TradesViewModel.TradeServerType?
    var totalCount = 0 {
        didSet {
            transactionsCount = "\(totalCount) trades"
        }
    }
    
    var viewModels = [ProgramDetailTradesTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ProgramDetailTradesRouter, investmentProgramId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.reloadDataProtocol = reloadDataProtocol
    }
}

// MARK: - TableView
extension ProgramDetailTradesViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramDetailTradesTableViewCellViewModel.self]
    }
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [ProgramDetailTradesHeaderView.self]
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func isMetaTrader5() -> Bool {
        return tradeServerType == TradesViewModel.TradeServerType.metaTrader5
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 44.0
    }
}

// MARK: - Fetch
extension ProgramDetailTradesViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels, tradeServerType) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels, tradeServerType: tradeServerType)
            }, completionError: completion)
    }
    
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Constants.Api.fetchThreshold == row && canFetchMoreResults {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels, tradeServerType) in
            var allViewModels = self?.viewModels ?? [ProgramDetailTradesTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, viewModels: allViewModels, tradeServerType: tradeServerType)
            }, completionError: { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
        })
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels, tradeServerType) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels, tradeServerType: tradeServerType)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> ProgramDetailTradesTableViewCellViewModel? {
        return viewModels[index]
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, viewModels: [ProgramDetailTradesTableViewCellViewModel], tradeServerType: TradesViewModel.TradeServerType?) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.tradeServerType = tradeServerType
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramDetailTradesTableViewCellViewModel], _ tradeServerType: TradesViewModel.TradeServerType?) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let investmentProgramId = investmentProgramId,
                let uuid = UUID(uuidString: investmentProgramId) else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            let filter = TradesFilter(investmentProgramId: uuid, dateFrom: nil, dateTo: nil, symbol: nil, sorting: nil, skip: skip, take: take)
            ProgramDataProvider.getProgramTrades(with: filter, completion: { (tradesViewModel) in
                guard tradesViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [ProgramDetailTradesTableViewCellViewModel]()
                
                let totalCount = tradesViewModel?.total ?? 0
                
                tradesViewModel?.trades?.forEach({ (orderModel) in
                    let viewModel = ProgramDetailTradesTableViewCellViewModel(orderModel: orderModel)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels, tradesViewModel?.tradeServerType)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            break
        }
    }
}


