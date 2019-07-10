//
//  DashboardFundListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class DashboardFundListViewModel: ListViewModelProtocol {
    // MARK: - Variables
    var title = "Funds"
    
    var assetType: AssetType = .fund
    
    var fundListDelegateManager: ListDelegateManager<DashboardFundListViewModel>!
    
    var highToLowValue: Bool = false
    
    var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    
    var filterModel: FilterModel = FilterModel()
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    var canPullToRefresh = false
    var canFetchMoreResults = true
    var skip = 0
    var take = ApiKeys.take
    var totalCount = 0 {
        didSet {
            title = totalCount > 0 ? "Funds \(totalCount)" : "Funds"
        }
    }
    
    var bottomViewType: BottomViewType = .filter
    
    var viewModels = [CellViewAnyModel]() {
        didSet {
            guard let viewModels = viewModels as? [DashboardFundTableViewCellViewModel] else { return }
            
            self.allViewModels = viewModels
        }
    }
    var allViewModels = [DashboardFundTableViewCellViewModel]()
    
    var facetsViewModels: [CellViewAnyModel]?
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        self.reloadDataProtocol = router.fundListViewController
        
        fundListDelegateManager = ListDelegateManager(with: self)

        NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? DashboardFundTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.fund.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        FundsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? DashboardFundTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.fund.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    // MARK: - Private methods
    @objc private func fundFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["fundId"] as? String {
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
}

// MARK: - TableView
extension DashboardFundListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardFundTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return allViewModels.count
    }
    
    func numberOfSections() -> Int {
        return modelsCount() > 0 ? sections.count : 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
}

// MARK: - Navigation
extension DashboardFundListViewModel {
    func logoImageName() -> String? {
        let imageName = "img_nodata_list"
        return imageName
    }
    
    func noDataText() -> String {
        return "You don’t have any funds yet"
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse assets"
        return text
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: DashboardFundTableViewCellViewModel = model(at: indexPath) as? DashboardFundTableViewCellViewModel else { return }

        let fund = model.fund
        guard let fundId = fund.id else { return }

        router.show(routeType: .showAssetDetails(assetId: fundId.uuidString, assetType: .fund))
    }
    
    func showFundList() {
        guard let router = router as? DashboardRouter else { return }
        router.show(routeType: .assetList)
    }
    
    func showFilterVC() {
        router.show(routeType: .showFilterVC(listViewModel: self, filterModel: self.filterModel, filterType: .dashboardFunds, sortingType: .dashboardFunds))
    }
}

// MARK: - Fetch
extension DashboardFundListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
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
            var models = self?.viewModels ?? [DashboardFundTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                models.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, models as! [DashboardFundTableViewCellViewModel])
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
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        return allViewModels[indexPath.row]
    }
    
    func model(at fundId: String) -> CellViewAnyModel? {
        if let i = allViewModels.firstIndex(where: { $0.fund.id?.uuidString == fundId }) {
            return allViewModels[i]
        }
        
        return nil
    }
    
    func getFundViewController(with indexPath: IndexPath) -> FundViewController? {
        guard let model = model(at: indexPath) as? DashboardFundTableViewCellViewModel else {
            return nil
        }

        let fund = model.fund
        guard let fundId = fund.id, let router = router as? DashboardRouter else { return nil}

        return router.getFundViewController(with: fundId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [DashboardFundTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [DashboardFundTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {

        DashboardDataProvider.getFundList(filterModel, skip: skip, take: take, completion: { [weak self] (fundList) in
            guard let fundList = fundList else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            var viewModels = [DashboardFundTableViewCellViewModel]()
            
            let totalCount = fundList.funds?.count ?? 0
            
            fundList.funds?.forEach({ (fund) in
                if let router = self?.router as? DashboardRouter {
                    let dashboardTableViewCellModel = DashboardFundTableViewCellViewModel(fund: fund, reloadDataProtocol: router.fundListViewController, delegate:
                        router.fundListViewController)
                    viewModels.append(dashboardTableViewCellModel)
                }
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
            }, errorCompletion: completionError)
    }
}

