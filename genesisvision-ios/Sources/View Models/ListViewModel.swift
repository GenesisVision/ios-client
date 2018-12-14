//
//  ListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ListViewState {
    case list, listWithSignIn
}

final class ListViewModel: ListViewModelProtocol {
    var filterModel: FilterModel = FilterModel()
    
    var assetType: AssetType
    
    // MARK: - Variables
    var title: String = ""

    internal var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    var state: ListViewState?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var canPullToRefresh = true
    var canFetchMoreResults = true
    
    var dataType: DataType = .api

    var skip = 0
    var take = Api.take
    var totalCount = 0

    var showFacets = false

    var bottomViewType: BottomViewType = .none
    
    var viewModels = [CellViewAnyModel]()
    var facetsViewModels: [CellViewAnyModel]?
    
    // MARK: - Init
    init(withRouter router: ListRouterProtocol, reloadDataProtocol: ReloadDataProtocol?, filterModel: FilterModel? = nil, showFacets: Bool = false, bottomViewType: BottomViewType? = .none, assetType: AssetType) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.showFacets = showFacets
        self.assetType = assetType
        
        state = isLogin() ? .list : .listWithSignIn

        if let bottomViewType = bottomViewType {
            self.bottomViewType = bottomViewType
        } else {
            var hasFilter = false
            
            if self.filterModel.mask == nil, self.filterModel.levelUpData == nil, self.filterModel.facetId == nil {
                hasFilter = true
            }
            
            self.bottomViewType = signInButtonEnable
                ? hasFilter ? .signInWithFilter : .signIn
                : hasFilter ? .filter : self.bottomViewType
        }
        
        switch assetType {
        case .program:
            title = "Programs"
            
            NotificationCenter.default.addObserver(self, selector: #selector(programFavoriteStateChangeNotification(notification:)), name: .programFavoriteStateChange, object: nil)
        case .fund:
            title = "Funds"
            
            NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
        default:
            break
        }
        
        if let filterModel = filterModel {
            self.filterModel = filterModel
            if let facetTitle = filterModel.facetTitle {
                self.title = (facetTitle == "Favorites" ? "Favorite" : facetTitle) + " " + title.lowercased()
            }
        }
    }
    
    deinit {
        switch assetType {
        case .program:
            NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
        case .fund:
            NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
        default:
            break
        }
    }
    
    // MARK: - Private methods
    private func setupFacets() {
        guard showFacets else { return }
        
        if !sections.contains(.facetList) {
            sections.insert(.facetList, at: 0)
        }
        
        var facets: [Facet] = []
        
        switch assetType {
        case .program:
            if let programsFacets = PlatformManager.shared.platformInfo?.programsFacets {
                facets.append(contentsOf: programsFacets)
            } else {
                PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
                    if let programsFacets = PlatformManager.shared.platformInfo?.programsFacets {
                        facets.append(contentsOf: programsFacets)
                        self?.updateFacets(facets)
                        self?.reloadDataProtocol?.didReloadData()
                    }
                }
            }
        case .fund:
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
        default:
            break
        }
        
        if isLogin() {
            facets.insert(Facet(id: nil, title: "Favorites", description: nil, logo: nil, url: nil, sortType: nil), at: 0)
        }

        self.updateFacets(facets)
    }
    
    private func updateFacets(_ facets: [Facet]) {
        let facetsViewModel = FacetsViewModel(withRouter: router, facets: facets, assetType: assetType)
        facetsViewModels = [FacetsTableViewCellViewModel(facetsViewModel: facetsViewModel)]
    }
    
    // MARK: - Public methods
    func noDataText() -> String {
        switch assetType {
        case .program:
            return "There are no programs"
        case .fund:
            return "There are no funds"
        default:
            return "There are no assets"
        }
    }
    
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    var signInButtonEnable: Bool {
        return state == .listWithSignIn
    }
    
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        switch assetType {
        case .program:
            changeFavoriteProgram(value: value, assetId: assetId, request: request, completion: completion)
        case .fund:
            changeFavoriteFund(value: value, assetId: assetId, request: request, completion: completion)
        default:
            break
        }
    }
    
    func changeFavoriteProgram(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.asset.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        
        ProgramsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.asset.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func changeFavoriteFund(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? FundTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.asset.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        
        FundsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? FundTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.asset.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func updateViewModels(_ assetList: ProgramsList?) {
        guard let assetList = assetList else { return }
        
        var viewModels = [ProgramTableViewCellViewModel]()
        
        let totalCount = assetList.total ?? 0
        
        assetList.programs?.forEach({ (asset) in
            guard let programListRouter = self.router as? ListRouter else { return }
            
            let viewModel = ProgramTableViewCellViewModel(asset: asset, isRating: filterModel.levelUpData != nil, delegate: programListRouter.currentController as? FavoriteStateChangeProtocol)
            viewModels.append(viewModel)
        })

        self.updateFetchedData(totalCount: totalCount, viewModels)
    }
    
    func updateViewModels(_ assetList: FundsList?) {
        guard let assetList = assetList else { return }

        var viewModels = [FundTableViewCellViewModel]()
        
        let totalCount = assetList.total ?? 0
        
        assetList.funds?.forEach({ (asset) in
            guard let fundListRouter = self.router as? ListRouter else { return }
            
            let viewModel = FundTableViewCellViewModel(asset: asset, delegate: fundListRouter.currentController as? FavoriteStateChangeProtocol)
            viewModels.append(viewModel)
        })
        
        self.updateFetchedData(totalCount: totalCount, viewModels)
    }
    
    // MARK: - Private methods
    @objc private func programFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["programId"] as? String {
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
    
    @objc private func fundFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["fundId"] as? String {
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
}

// MARK: - Fetch
extension ListViewModel {
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
            var allViewModels = self?.viewModels ?? [CellViewAnyModel]()

            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })

            self?.updateFetchedData(totalCount: totalCount, allViewModels)
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
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [CellViewAnyModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }

    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [CellViewAnyModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        var viewModels = [CellViewAnyModel]()
        var totalCount = 0
        
        switch assetType {
        case .program:
            ProgramsDataProvider.get(filterModel, skip: skip, take: take, completion: { [weak self] (assetList) in
                guard let assetList = assetList else { return completionError(.failure(errorType: .apiError(message: nil))) }
                
                totalCount = assetList.total ?? 0
                
                assetList.programs?.forEach({ (asset) in
                    guard let listRouter = self?.router as? ListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let programTableViewCellViewModel = ProgramTableViewCellViewModel(asset: asset, isRating: self?.filterModel.levelUpData != nil, delegate: listRouter.currentController as? FavoriteStateChangeProtocol)
                    viewModels.append(programTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
                }, errorCompletion: completionError)
        case .fund:
            FundsDataProvider.get(filterModel, skip: skip, take: take, completion: { [weak self] (assetList) in
                guard let assetList = assetList else { return completionError(.failure(errorType: .apiError(message: nil))) }

                totalCount = assetList.total ?? 0
                
                assetList.funds?.forEach({ (asset) in
                    guard let listRouter = self?.router as? ListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let fundTableViewCellViewModel = FundTableViewCellViewModel(asset: asset, delegate: listRouter.currentController as? FavoriteStateChangeProtocol)
                    viewModels.append(fundTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
                }, errorCompletion: completionError)
        default:
            break
        }
    }
}
