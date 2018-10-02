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
    var title: String = "Profit".uppercased()
    var investmentProgramId: String?
    
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
    
    private var models: [CellViewAnyModel]?
    
    private var sections: [SectionType] = [.chart, .statistics]
    
    // MARK: - Init
    init(withRouter router: Router, investmentProgramId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.reloadDataProtocol = reloadDataProtocol
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
}

// MARK: - Fetch
extension ProgramProfitViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
//            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }

    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
//            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }

    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramProfitChartTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let investmentProgramId = investmentProgramId,
                let uuid = UUID(uuidString: investmentProgramId) else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            let filter = TransactionsFilter(investmentProgramId: uuid, type: nil, skip: skip, take: take)
            WalletDataProvider.getWalletTransactions(with: filter, completion: { (transactionsViewModel) in
                guard transactionsViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [ProgramProfitChartTableViewCellViewModel]()
                
                let totalCount = transactionsViewModel?.total ?? 0
                
                transactionsViewModel?.transactions?.forEach({ (walletTransaction) in
                    let viewModel = ProgramProfitChartTableViewCellViewModel()
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
