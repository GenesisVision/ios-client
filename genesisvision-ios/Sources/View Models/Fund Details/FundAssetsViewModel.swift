//
//  FundAssetsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 29/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class FundAssetsViewModel {
    // MARK: - Variables
    var title: String = "Structure"
    var fundId: String?
    
    var router: FundRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var assetsCount: String = ""
    var skip = 0
    var take = ApiKeys.take
    
    var totalCount = 0 {
        didSet {
            assetsCount = "\(totalCount) assets"
        }
    }
    
    var viewModels = [FundAssetTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: FundRouter, fundId: String, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.fundId = fundId
        self.reloadDataProtocol = reloadDataProtocol
    }
    
    func hideHeader(value: Bool = true) {
        router.fundViewController.hideHeader(value)
    }
}

// MARK: - TableView
extension FundAssetsViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundAssetTableViewCellViewModel.self]
    }
    
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [FundAssetsHeaderView.self]
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
    
    func rowHeight(for row: Int) -> CGFloat {
        return 50.0
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 40.0
    }
}

// MARK: - Fetch
extension FundAssetsViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            }, completionError: completion)
    }
    
    func fetchMore(at indexPath: IndexPath) -> Bool {
        if modelsCount() - ApiKeys.fetchThreshold == indexPath.row && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [FundAssetTableViewCellViewModel]()
            
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
    func model(for indexPath: IndexPath) -> FundAssetTableViewCellViewModel? {
        return viewModels[indexPath.row]
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, viewModels: [FundAssetTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [FundAssetTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let fundId = fundId else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            FundsDataProvider.getAssets(fundId: fundId, completion: { (assetsViewModel) in
                guard assetsViewModel != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [FundAssetTableViewCellViewModel]()
                
                let totalCount = assetsViewModel?.assets?.count ?? 0
                
                assetsViewModel?.assets?.forEach({ (assetInfo) in
                    let viewModel = FundAssetTableViewCellViewModel(fundAssetInfo: assetInfo)
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



