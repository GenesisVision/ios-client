//
//  ProgramHistoryViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ProgramHistoryViewModel {
    // MARK: - Variables
    var title: String = "History"
    var investmentProgramId: String?
    
    var router: ProgramHistoryRouter!
    
    var dataType: DataType = .api
    
    var transactionsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            transactionsCount = "\(totalCount) transactions"
        }
    }

    var viewModels = [WalletTransactionTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ProgramHistoryRouter, investmentProgramId: String) {
        self.router = router
        self.investmentProgramId = investmentProgramId
    }
}

// MARK: - TableView
extension ProgramHistoryViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletTransactionTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Fetch
extension ProgramHistoryViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func fetchMore(completion: @escaping CompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += Constants.Api.take
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [WalletTransactionTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
            }, completionError: completion)
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> WalletTransactionTableViewCellViewModel? {
        return viewModels[index]
    }

    // MARK: - Private methods
   private func updateFetchedData(totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            WalletDataProvider.getWalletTransactions(withProgramId: investmentProgramId, type: nil, skip: skip, take: take) { (transactionsViewModel) in
                guard transactionsViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [WalletTransactionTableViewCellViewModel]()
                
                let totalCount = transactionsViewModel?.total ?? 0
                
                transactionsViewModel?.transactions?.forEach({ (walletTransaction) in
                    let viewModel = WalletTransactionTableViewCellViewModel(walletTransaction: walletTransaction)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }
        case .fake:
            break
        }
    }
}

