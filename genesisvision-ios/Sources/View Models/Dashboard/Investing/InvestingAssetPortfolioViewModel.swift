//
//  InvestingAssetPortfolioViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 26.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

protocol historyReloadProtocol {
    func reload(assets: [String]?, dateFrom: Date?, dateTo: Date?, filterModel: FilterModel?)
}

final class InvestingAssetPortfolioViewModel {

    typealias SectionType = InvestingPortfolioSectionType
    
    // MARK: - Variables
    var title: String = "Assets"
    
    private var sections: [SectionType] = [.portfolio, .history]
    private var type: SectionType = .portfolio
    private var router: Router!
    private var viewModels = [CellViewAnyModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private var filterModel = FilterModel()
    var totalCount = 0
    var bottomViewType: BottomViewType {
        switch type {
        case .portfolio:
            return .none
        case .history:
            return .filter
        }
    }
    
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
    func showFilterVC() {
        let listViewModel = ListViewModel(withRouter: router as! ListRouterProtocol, reloadDataProtocol: reloadDataProtocol, assetType: .coinAsset)
        listViewModel.historyDelegate = self
        listViewModel.filterModel = filterModel
        router.showFilterVC(with: listViewModel, filterModel: filterModel, filterType: .history, sortingType: .assets)
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
    
    func fetch(_ assets: [String]? = nil, dateFrom: Date? = nil, dateTo: Date? = nil, completion: @escaping CompletionBlock) {
        switch type {
        case .portfolio:
            fetchPortfolio({ [weak self] (totalCount, viewModels) in
                self?.updateFetchedData(totalCount: totalCount, viewModels)
                completion(.success)
                self?.reloadDataProtocol?.didReloadData()
            }, completionError: completion)
        case .history:
            fetchHistory(assets: assets, dateFrom: dateFrom, dateTo: dateTo, { [weak self] totalCount, viewModels in
                self?.updateFetchedData(totalCount: totalCount, viewModels)
                completion(.success)
                self?.reloadDataProtocol?.didReloadData()
            }, completionError: completion)
        }
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
    private func fetchHistory(assets: [String]? = nil, dateFrom: Date? = nil, dateTo: Date? = nil,_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [CoinAssetHistoryTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        CoinAssetsDataProvider.getCoinsHistory(dateFrom: dateFrom, dateTo: dateTo, assets: assets) { coinsHistoryEventItemsViewModel, error in
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

extension InvestingAssetPortfolioViewModel: historyReloadProtocol {
    func reload(assets: [String]? = nil, dateFrom: Date? = nil, dateTo: Date? = nil, filterModel: FilterModel?) {
        fetch(assets, dateFrom: dateFrom, dateTo: dateTo) { result in
            guard let filterModel = filterModel else { return }
            self.filterModel = filterModel
        }
    }
}
