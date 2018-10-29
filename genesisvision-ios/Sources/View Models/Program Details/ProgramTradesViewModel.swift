//
//  ProgramTradesViewModel.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ProgramTradesViewModel {
    // MARK: - Variables
    var title: String = "Trades"
    var programId: String?
    
    var router: ProgramRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var sortingDelegateManager: SortingDelegateManager!
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var transactionsCount: String = ""
    var dateFrom: Date?
    var dateTo: Date?
    var skip = 0
    var take = Constants.Api.take

    var totalCount = 0 {
        didSet {
            transactionsCount = "\(totalCount) trades"
        }
    }
    
    var viewModels = [ProgramTradesTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ProgramRouter, programId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.programId = programId
        self.reloadDataProtocol = reloadDataProtocol
        
        sortingDelegateManager = SortingDelegateManager(.trades)
    }

    func hideHeader(value: Bool = true) {
        router.programViewController.hideHeader(value)
    }
}

// MARK: - TableView
extension ProgramTradesViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramTradesTableViewCellViewModel.self]
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
        return true
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - Fetch
extension ProgramTradesViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
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
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [ProgramTradesTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, viewModels: allViewModels)
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
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> ProgramTradesTableViewCellViewModel? {
        return viewModels[index]
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, viewModels: [ProgramTradesTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTradesTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let programId = programId else { return completionError(.failure(errorType: .apiError(message: nil))) }

            let sorting = sortingDelegateManager.sortingManager?.getSelectedSorting()
            ProgramsDataProvider.getTrades(with: programId, dateFrom: dateFrom, dateTo: dateTo, sorting: sorting as? ProgramsAPI.Sorting_v10ProgramsByIdTradesGet, skip: skip, take: take, completion: { (tradesViewModel) in
                guard tradesViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [ProgramTradesTableViewCellViewModel]()
                
                let totalCount = tradesViewModel?.total ?? 0
                
                tradesViewModel?.trades?.forEach({ (orderModel) in
                    let viewModel = ProgramTradesTableViewCellViewModel(orderModel: orderModel)
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


