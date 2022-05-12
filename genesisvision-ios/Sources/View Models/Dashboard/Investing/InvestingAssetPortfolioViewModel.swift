//
//  InvestingAssetPortfolioViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 26.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class InvestingAssetPortfolioViewModel {

    typealias SectionType = InvestingPortfolioSectionType
    
    // MARK: - Variables
    var title: String = "Transactions"
    
    private var sections: [SectionType] = [.portfolio]
    private var type: SectionType = .portfolio
    private var router: Router!
    private var viewModels = [CellViewAnyModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var totalCount = 0
    
    // MARK: - Init
    init(withRouter router: Router, reloadDataProtocol: ReloadDataProtocol, type: SectionType) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.sections = [type]
        self.type = type
    }
    
    func showAssetDetails(with assetId: String, assetType: AssetType) {
        router.showAssetDetails(with: assetId, assetType: assetType)
    }
}

// MARK: - TableView
extension InvestingAssetPortfolioViewModel {
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [CoinAssetPortfolioTableViewCellViewModel.self,
                CoinAssetHistoryTableViewCellViewModel.self]
    }
        
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .portfolio, .history:
            return viewModels.count
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .portfolio:
            return "Portfolio"
        case .history:
            return "History"
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .portfolio, .history:
            return 78.0
        }
    }
    
    func rowHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .portfolio:
            return 70
        case .history:
            return 220
        }
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .portfolio, .history:
            return viewModels[indexPath.row]
        }
    }
}

// MARK: - Fetch
extension InvestingAssetPortfolioViewModel {
    
    func fetch(completion: @escaping CompletionBlock) {
        switch type {
        case .portfolio:
            fetchPortfolio({ [weak self] (totalCount, viewModels) in
                self?.updateFetchedData(totalCount: totalCount, viewModels)
                completion(.success)
            }, completionError: completion)
        case .history:
            fetchHistory ({ [weak self] totalCount, viewModels in
                self?.updateFetchedData(totalCount: totalCount, viewModels)
                completion(.success)
            }, completionError: completion)
        }
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        fetch(completion: { result in
        })
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [CellViewAnyModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetchPortfolio(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [CoinAssetPortfolioTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        CoinAssetsDataProvider.getCoinsPortfolio { coinsAssetItemsViewModel in
            var viewModels = [CoinAssetPortfolioTableViewCellViewModel]()
            let totalCount = coinsAssetItemsViewModel?.total ?? 0
            coinsAssetItemsViewModel?.items?.forEach({ (viewModel) in
                let viewModel = CoinAssetPortfolioTableViewCellViewModel(coinAsset: viewModel)
                let cell = CoinAssetTableViewCell(style: .default, reuseIdentifier: CoinAssetTableViewCell.identifier)
                viewModel.setup(on: cell)
                viewModels.append(viewModel)
            })
            
            completionSuccess(totalCount, viewModels)
        } errorCompletion: { result in
        
        }
    }
    
    private func fetchHistory(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [CoinAssetHistoryTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        CoinAssetsDataProvider.getCoinsHistory { coinsHistoryEventItemsViewModel, error in
            var viewModels = [CoinAssetHistoryTableViewCellViewModel]()
            let totalCount = coinsHistoryEventItemsViewModel?.total ?? 0
            coinsHistoryEventItemsViewModel?.items?.forEach({ (viewModel) in
                let viewModel = CoinAssetHistoryTableViewCellViewModel(coinsHistoryEvent: viewModel)
                let cell = CoinAssetTableViewCell(style: .default, reuseIdentifier: CoinAssetTableViewCell.identifier)
                viewModel.setup(on: cell)
                viewModels.append(viewModel)
            })
            completionSuccess(totalCount, viewModels)
        }
    }
}

extension InvestingAssetPortfolioViewModel {
    func logoImageName() -> String {
        let imageName = "img_wallet_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "You don’t have any transactions yet"
    }
    
    func noDataImageName() -> String? {
        return nil
    }
    
    func noDataButtonTitle() -> String {
        let text = ""
        return text
    }
}
