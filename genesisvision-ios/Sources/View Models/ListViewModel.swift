//
//  ListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum ListViewState {
    case list, listWithSignIn
}

final class ListViewModel: ListViewModelProtocol {
    var filterModel: FilterModel = FilterModel()
    
    var assetType: AssetType
    
    var assetListDelegateManager: ListDelegateManager<ListViewModel>!
    
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
    var take = ApiKeys.take
    var totalCount = 0 {
        didSet {
        }
    }

    var showFacets = false

    var bottomViewType: BottomViewType = .none
    
    var viewModels = [CellViewAnyModel]()
    var facetsViewModels: [CellViewAnyModel]?
    
    var signInButtonEnable: Bool {
        return state == .listWithSignIn
    }
    
    // MARK: - Init
    init(withRouter router: ListRouterProtocol, reloadDataProtocol: ReloadDataProtocol?, filterModel: FilterModel? = nil, showFacets: Bool = false, bottomViewType: BottomViewType? = nil, assetType: AssetType) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.showFacets = showFacets
        self.assetType = assetType
        
        assetListDelegateManager = ListDelegateManager(with: self)
        
        state = isLogin() ? .list : .listWithSignIn

        if let bottomViewType = bottomViewType {
            self.bottomViewType = bottomViewType
        } else {
            var hasFilter = false
            
            if self.filterModel.mask == nil, self.filterModel.facetTitle != "", self.filterModel.facetId == nil {
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
        case .follow:
            title = "Follow"
            
            NotificationCenter.default.addObserver(self, selector: #selector(followFavoriteStateChangeNotification(notification:)), name: .followFavoriteStateChange, object: nil)
        default:
            break
        }
        
        if let filterModel = filterModel {
            self.filterModel = filterModel
            if let facetTitle = filterModel.facetTitle {
                self.title = (facetTitle == "Favorites" ? "Favorite" : facetTitle) + " " + title.lowercased()
                
                if facetTitle == "Rating" {
                    self.bottomViewType = .none
                }
            }
        }
    }
    
    deinit {
        switch assetType {
        case .program:
            NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
        case .fund:
            NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
        case .follow:
            NotificationCenter.default.removeObserver(self, name: .followFavoriteStateChange, object: nil)
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
        
        var programFacets: [AssetFacet] = []
        var fundFacets: [AssetFacet] = []
        var followFacets: [AssetFacet] = []
        
        let favoritesFacet = AssetFacet(_id: nil, title: "Favorites", _description: nil, logoUrl: nil, url: nil, sortType: nil, timeframe: nil, sorting: nil)        
        
        switch assetType {
        case .program:
            if isLogin() {
                programFacets.insert(favoritesFacet, at: 0)
            }
            if let facets = PlatformManager.shared.platformInfo?.assetInfo?.programInfo?.facets {
                programFacets.append(contentsOf: facets)
                updateFacets(programFacets)
            } else {
                PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
                    if let facets = PlatformManager.shared.platformInfo?.assetInfo?.programInfo?.facets {
                        programFacets.append(contentsOf: facets)
                        self?.updateFacets(programFacets)
                        self?.reloadDataProtocol?.didReloadData()
                    }
                }
            }
        case .fund:
            if isLogin() {
                fundFacets.insert(favoritesFacet, at: 0)
            }
            if let facets = PlatformManager.shared.platformInfo?.assetInfo?.fundInfo?.facets {
                fundFacets.append(contentsOf: facets)
                updateFacets(fundFacets)
            } else {
                PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
                    if let facets = PlatformManager.shared.platformInfo?.assetInfo?.fundInfo?.facets {
                        fundFacets.append(contentsOf: facets)
                        self?.updateFacets(fundFacets)
                        self?.reloadDataProtocol?.didReloadData()
                    }
                }
            }
        case .follow:
            if isLogin() {
                followFacets.insert(favoritesFacet, at: 0)
            }
            if let facets = PlatformManager.shared.platformInfo?.assetInfo?.followInfo?.facets {
                followFacets.append(contentsOf: facets)
                updateFacets(followFacets)
            } else {
                PlatformManager.shared.getPlatformInfo { [weak self] (platformInfo) in
                    if let facets = PlatformManager.shared.platformInfo?.assetInfo?.followInfo?.facets {
                        followFacets.append(contentsOf: facets)
                        self?.updateFacets(followFacets)
                        self?.reloadDataProtocol?.didReloadData()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func updateFacets(_ facets: [AssetFacet]) {
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
        case .follow:
            return "There are no follows"
        default:
            return "There are no assets"
        }
    }
    
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        switch assetType {
        case .program:
            changeFavoriteProgram(value: value, assetId: assetId, request: request, completion: completion)
        case .fund:
            changeFavoriteFund(value: value, assetId: assetId, request: request, completion: completion)
        case .follow:
            changeFavoriteFollow(value: value, assetId: assetId, request: request, completion: completion)
        default:
            break
        }
    }
    
    func changeFavoriteProgram(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {

            var programModel = model(for: assetId) as? ProgramTableViewCellViewModel

            if programModel != nil {
                programModel!.asset.personalDetails?.isFavorite = value
                completion(.success)
                return
            } else { return completion(.failure(errorType: .apiError(message: nil))) }

        }
        
        
        ProgramsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                var programModel = self?.model(for: assetId) as? ProgramTableViewCellViewModel
                
                if programModel != nil {
                    programModel!.asset.personalDetails?.isFavorite = value
                    completion(.success)
                } else {
                    return completion(.failure(errorType: .apiError(message: nil)))
                }
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func changeFavoriteFund(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            var fundModel = model(for: assetId) as? FundTableViewCellViewModel
            
            if fundModel != nil {
                fundModel!.asset.personalDetails?.isFavorite = value
                completion(.success)
                return
            } else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
        }
        
        
        FundsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                var fundModel = self?.model(for: assetId) as? FundTableViewCellViewModel
                
                if fundModel != nil {
                    fundModel!.asset.personalDetails?.isFavorite = value
                    completion(.success)
                    return
                } else {
                    return completion(.failure(errorType: .apiError(message: nil)))
                }
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func changeFavoriteFollow(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            var followModel = model(for: assetId) as? FollowTableViewCellViewModel
            
            if followModel != nil {
                followModel!.asset.personalDetails?.isFavorite = value
                completion(.success)
                return
            } else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
        }

        FollowsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                var followModel = self?.model(for: assetId) as? FollowTableViewCellViewModel
                
                if followModel != nil {
                    followModel!.asset.personalDetails?.isFavorite = value
                    completion(.success)
                    return
                }
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func updateViewModels(_ assetList: ProgramDetailsListItemItemsViewModel?) {
        guard let assetList = assetList else { return }
        
        var viewModels = [ProgramTableViewCellViewModel]()
        
        let totalCount = assetList.total ?? 0
        
        assetList.items?.forEach({ (asset) in
            guard let router = self.router as? ListRouter else { return }
            
            let viewModel = ProgramTableViewCellViewModel(asset: asset, filterProtocol: router.currentController as? FilterChangedProtocol, favoriteProtocol: router.currentController as? FavoriteStateChangeProtocol) //FIXIT:
            viewModels.append(viewModel)
        })

        self.updateFetchedData(totalCount: totalCount, viewModels)
    }
    
    func updateViewModels(_ assetList: FundDetailsListItemItemsViewModel?) {
        guard let assetList = assetList else { return }

        var viewModels = [FundTableViewCellViewModel]()
        
        let totalCount = assetList.total ?? 0
        
        assetList.items?.forEach({ (asset) in
            guard let router = self.router as? ListRouter else { return }
            
            let viewModel = FundTableViewCellViewModel(asset: asset, filterProtocol: router.currentController as? FilterChangedProtocol, favoriteProtocol: router.currentController as? FavoriteStateChangeProtocol) //FIXIT:b
            viewModels.append(viewModel)
        })
        
        self.updateFetchedData(totalCount: totalCount, viewModels)
    }
    
    func updateViewModels(_ assetList: FollowDetailsListItemItemsViewModel?) {
        guard let assetList = assetList else { return }

        var viewModels = [FollowTableViewCellViewModel]()
        
        let totalCount = assetList.total ?? 0
        
        assetList.items?.forEach({ (asset) in
            guard let router = self.router as? ListRouter else { return }
            
            let viewModel = FollowTableViewCellViewModel(asset: asset, filterProtocol: router.currentController as? FilterChangedProtocol, favoriteProtocol: router.currentController as? FavoriteStateChangeProtocol) //FIXIT:
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
    
    @objc private func followFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["followId"] as? String {
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu? {
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
            
            guard let assetType = self?.assetType else { return }
            
            var url: String?
            
            switch self?.assetType {
            case .program:
                if let model = self?.model(for: indexPath) as? ProgramTableViewCellViewModel, let name = model.asset.url {
                    url = getRoute(assetType, name: name)
                }
            case .fund:
                if let model = self?.model(for: indexPath) as? FundTableViewCellViewModel, let name = model.asset.url {
                    url = getRoute(assetType, name: name)
                }
            case .follow:
                if let model = self?.model(for: indexPath) as? FollowTableViewCellViewModel, let name = model.asset.url {
                    url = getRoute(assetType, name: name)
                }
            default:
                break
            }
            
            if let url = url {
                self?.router.show(routeType: .share(url: url))
            }
        }
        
        return UIMenu(title: "", children: [share])
    }
}

// MARK: - Fetch
extension ListViewModel {
    // MARK: - Public methods
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
            completion(.success)
            return
        }
        
        skip = 0
        setupFacets()
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            completion(.success)
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
                
                assetList.items?.forEach({ (asset) in
                    guard let listRouter = self?.router as? ListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let programTableViewCellViewModel = ProgramTableViewCellViewModel(asset: asset, filterProtocol: listRouter.currentController as? FilterChangedProtocol, favoriteProtocol: listRouter.currentController as? FavoriteStateChangeProtocol) //FIXIT:
                    viewModels.append(programTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                }, errorCompletion: completionError)
        case .fund:
            FundsDataProvider.get(filterModel, skip: skip, take: take, completion: { [weak self] (assetList) in
                guard let assetList = assetList else { return completionError(.failure(errorType: .apiError(message: nil))) }

                totalCount = assetList.total ?? 0
                
                assetList.items?.forEach({ (asset) in
                    guard let listRouter = self?.router as? ListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let fundTableViewCellViewModel = FundTableViewCellViewModel(asset: asset, filterProtocol: listRouter.currentController as? FilterChangedProtocol, favoriteProtocol: listRouter.currentController as? FavoriteStateChangeProtocol) //FIXIT:
                    viewModels.append(fundTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                }, errorCompletion: completionError)
        case .follow:
            FollowsDataProvider.get(filterModel, skip: skip, take: take, completion: { [weak self] (assetList) in
                guard let assetList = assetList else { return completionError(.failure(errorType: .apiError(message: nil))) }

                totalCount = assetList.total ?? 0
                
                assetList.items?.forEach({ (asset) in
                    guard let listRouter = self?.router as? ListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let followTableViewCellViewModel = FollowTableViewCellViewModel(asset: asset, filterProtocol: listRouter.currentController as? FilterChangedProtocol, favoriteProtocol: listRouter.currentController as? FavoriteStateChangeProtocol) //FIXIT:
                    viewModels.append(followTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                }, errorCompletion: completionError)
        default:
            break
        }
    }
}
