//
//  ProgramBalanceViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ProgramBalanceViewModel {
    enum SectionType {
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Balance".uppercased()
    var programId: String?
    
    var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var transactionsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            transactionsCount = "\(totalCount) transactions"
        }
    }
    
    private var models: [ProgramBalanceChartTableViewCellViewModel]?
    
    private var sections: [SectionType] = [.chart]
    
    // MARK: - Init
    init(withRouter router: Router, programId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.programId = programId
        self.reloadDataProtocol = reloadDataProtocol
    }
}

// MARK: - TableView
extension ProgramBalanceViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramBalanceChartTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return models?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Fetch
extension ProgramBalanceViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> ProgramBalanceChartTableViewCellViewModel? {
        return models?[index]
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [ProgramBalanceChartTableViewCellViewModel]) {
        self.models = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramBalanceChartTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let programId = programId,
                let uuid = UUID(uuidString: programId) else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            WalletDataProvider.getWalletTransactions(with: uuid, from: nil, to: nil, assetType: nil, txAction: nil, skip: skip, take: take, completion: { (transactionsViewModel) in
                guard transactionsViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [ProgramBalanceChartTableViewCellViewModel]()
                
                let totalCount = transactionsViewModel?.total ?? 0
                
                transactionsViewModel?.transactions?.forEach({ (walletTransaction) in
                    let viewModel = ProgramBalanceChartTableViewCellViewModel()
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            break
        }
    }
}
