//
//  FundListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum FundListViewState {
    case fundList, fundListWithSignIn
}

final class FundListViewModel: ListViewModelProtocol {
    var filterModel: FilterModel = FilterModel()
    
    // MARK: - Variables
    var assetType: AssetType = .fund
    var title: String = "Funds"
    var roundNumber: Int = 1
    
    var sortingDelegateManager: SortingDelegateManager!
    
    internal var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    var state: FundListViewState?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var canFetchMoreResults = true
    var dataType: DataType = .api

    var chartPointsCount = Api.equityChartLength
    var skip = 0
    var take = Api.take
    var totalCount = 0

    var showFacets = false
    
    private var fundsList: FundsList?

    var dateFrom: Date?
    var dateTo: Date?
    
    var bottomViewType: BottomViewType {
        return signInButtonEnable ? .signInWithFilter : .filter
    }
    
    var viewModels = [CellViewAnyModel]()
    var facetsViewModels: [CellViewAnyModel]?
    
    // MARK: - Init
    init(withRouter router: FundListRouter, reloadDataProtocol: ReloadDataProtocol?, filterModel: FilterModel? = nil, showFacets: Bool = false) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.showFacets = showFacets
        
        if let filterModel = filterModel {
            self.filterModel = filterModel
            if let facetTitle = filterModel.facetTitle {
                self.title = facetTitle + " " + title.lowercased()
            }
        }
        
        state = isLogin() ? .fundList : .fundListWithSignIn
        let sortingManager = SortingManager(.funds)
        sortingDelegateManager = SortingDelegateManager(sortingManager)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
    }
    
    // MARK: - Private methods
    private func setupFacets() {
        guard showFacets else { return }
        
        if !sections.contains(.facetList) {
            sections.insert(.facetList, at: 0)
        }
        
        var facets: [Facet] = []
        
        if let fundsFacets = PlatformManager.shared.platformInfo?.fundsFacets {
            facets.append(contentsOf: fundsFacets)
        } else {
            PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
                if let fundsFacets = PlatformManager.shared.platformInfo?.fundsFacets {
                    facets.append(contentsOf: fundsFacets)
                    self?.updateFacets(facets)
                    self?.reloadDataProtocol?.didReloadData()
                }
            }
        }
        
        if isLogin() {
            facets.insert(Facet(id: nil, title: "Favorites", description: nil, logo: nil, url: nil, sortType: nil), at: 0)
        }
        
        updateFacets(facets)
    }
    
    private func updateFacets(_ facets: [Facet]) {
        let facetsViewModel = FacetsViewModel(withRouter: router, facets: facets, assetType: assetType)
        facetsViewModels = [FacetsTableViewCellViewModel(facetsViewModel: facetsViewModel)]
    }
    
    // MARK: - Public methods
    func noDataText() -> String {
        return "There are no funds"
    }
    
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    var signInButtonEnable: Bool {
        return state == .fundListWithSignIn
    }
    
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? FundTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.fund.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        
        FundsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? FundTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
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

// MARK: - Fetch
extension FundListViewModel {
    // MARK: - Public methods
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Api.fetchThreshold == row && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }

        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [FundTableViewCellViewModel]()

            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })

            self?.updateFetchedData(totalCount: totalCount, allViewModels as! [FundTableViewCellViewModel])
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
        if let mask = filterModel.mask, mask.isEmpty {
            updateFetchedData(totalCount: 0, [])
            return
        }
        
        skip = 0
        setupFacets()
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [FundTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }

    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [FundTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            FundsDataProvider.get(filterModel, skip: skip, take: take, completion: { [weak self] (fundsList) in
                guard let fundsList = fundsList else { return completionError(.failure(errorType: .apiError(message: nil))) }
                print(fundsList)
                self?.fundsList = fundsList
                
                var viewModels = [FundTableViewCellViewModel]()
                
                let totalCount = fundsList.total ?? 0
                
                fundsList.funds?.forEach({ (fund) in
                    guard let fundListRouter: FundListRouter = self?.router as? FundListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let fundTableViewCellViewModel = FundTableViewCellViewModel(fund: fund, delegate: fundListRouter.currentController as? FundListViewController)
                    viewModels.append(fundTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            break
        }
    }
}
