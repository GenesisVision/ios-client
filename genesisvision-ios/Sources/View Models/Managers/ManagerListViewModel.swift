//
//  ManagerListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class ManagerListViewModel: ListViewModelProtocol {
    var filterModel: FilterModel = FilterModel()
    
    // MARK: - Variables
    var assetType: AssetType = ._none 
    var title: String = "Managers"
    
    internal var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    
    var assetListDelegateManager: ListDelegateManager<ListViewModel>!
    
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var canPullToRefresh = true
    var canFetchMoreResults = true
    var dataType: DataType = .api
    
    var chartPointsCount = ApiKeys.equityChartLength
    var skip = 0
    var take = ApiKeys.take
    var totalCount = 0 {
        didSet {
        }
    }
    
    var showFacets = false
    
    var bottomViewType: BottomViewType {
        return filterModel.mask == nil ? .filter : .none
    }
    
    var viewModels = [CellViewAnyModel]()
    var facetsViewModels: [CellViewAnyModel]?
    
    // MARK: - Init
    init(withRouter router: ListRouterProtocol, reloadDataProtocol: ReloadDataProtocol?, filterModel: FilterModel? = nil, showFacets: Bool = false) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.showFacets = showFacets
        
        if let filterModel = filterModel {
            self.filterModel = filterModel
            if let facetTitle = filterModel.facetTitle {
                self.title = facetTitle + " " + title.lowercased()
            }
        }
    }
    
    // MARK: - Public methods
    func noDataText() -> String {
        return "There are no managers"
    }
    
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    var signInButtonEnable: Bool {
        return false
    }
    
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        //TODO: in future
    }
    
    func updateViewModels(_ managerList: PublicProfileItemsViewModel?) {
        guard let managerList = managerList else { return }

        var viewModels = [ManagerTableViewCellViewModel]()
        
        let totalCount = managerList.total ?? 0
        
        managerList.items?.forEach({ (profile) in
            let managerTableViewCellViewModel = ManagerTableViewCellViewModel(profile: profile, selectable: true)
            viewModels.append(managerTableViewCellViewModel)
        })
        
        self.updateFetchedData(totalCount: totalCount, viewModels)
    }
}

// MARK: - Fetch
extension ManagerListViewModel {
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
        //TODO: in future
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        //TODO: in future
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [ManagerTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ManagerTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        //TODO: in future
    }
}

