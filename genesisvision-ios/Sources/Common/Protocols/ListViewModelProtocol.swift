//
//  ListViewModelProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

protocol ListViewModelProtocolWithFacets {
    var facets: [Facet]? { get }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
    
    func didSelectFacet(at: IndexPath)
    func numberOfItems(in section: Int) -> Int
    func model(at indexPath: IndexPath) -> FacetCollectionViewCellViewModel?
}

final class FacetsViewModel: ListViewModelProtocolWithFacets {
    var facets: [Facet]?
    var router: ListRouterProtocol!
    var facetsDelegateManager: FacetsDelegateManager!
    
    var assetType: AssetType = .program
    
    init(withRouter router: ListRouterProtocol, facets: [Facet]?, assetType: AssetType) {
        self.router = router
        self.facets = facets
        self.assetType = assetType
        
        facetsDelegateManager = FacetsDelegateManager(with: self)
    }
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FacetCollectionViewCellViewModel.self]
    }
    
    func didSelectFacet(at indexPath: IndexPath) {
        guard let facets = facets, !facets.isEmpty else {
            return
        }
        
        let facet = facets[indexPath.row]
        
        let filterModel = FilterModel()
        
        if let facetTitle = facet.title {
            filterModel.facetTitle = facetTitle
        }
        
        if let uuid = facet.id?.uuidString {
            filterModel.facetId = uuid
        }
        
        filterModel.isFavorite = filterModel.facetTitle == "Favorites"
        let sortType = facet.sortType
        
        if sortType != nil, sortType == .toLevelUp {
            router.show(routeType: .showRatingList(filterModel: filterModel))
        } else {
            router.show(routeType: .showAssetList(filterModel: filterModel, assetType: assetType))
        }
    }
    
    func numberOfItems(in section: Int) -> Int {
        return facets?.count ?? 0
    }
    
    func model(at indexPath: IndexPath) -> FacetCollectionViewCellViewModel? {
        let facet = facets?[indexPath.row]

        let isFavoriteFacet = facet?.id == nil
        let model = FacetCollectionViewCellViewModel(facet: facet, isFavoriteFacet: isFavoriteFacet)
        return model
    }
}

protocol ListViewModelProtocol {
    var router: ListRouterProtocol! { get }
    
    var assetType: AssetType { get }
    
    var title: String { get }

    var sections: [SectionType] { get }
    var bottomViewType: BottomViewType { get } 
    
    var viewModels: [CellViewAnyModel] { get set }
    var facetsViewModels: [CellViewAnyModel]? { get set }
    
    var canPullToRefresh: Bool { get set }
    var canFetchMoreResults: Bool { get set }
    var filterModel: FilterModel { get set }
    
    var skip: Int { get set }
    var take: Int { get set }
    var totalCount: Int { get set }
    
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] { get }
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
    
    func refresh(completion: @escaping CompletionBlock)
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel?
    func model(at assetId: String) -> CellViewAnyModel?
    func modelsCount() -> Int
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    
    func showDetail(with assetId: String)
    func showDetail(at indexPath: IndexPath)
    
    func fetchMore(at row: Int) -> Bool
    func fetchMore()
    
    func getDetailsViewController(with indexPath: IndexPath) -> BaseViewController?
    func changeFavorite(value: Bool, assetId: String, request: Bool, completion: @escaping CompletionBlock)
    
    func logoImageName() -> String?
    func noDataText() -> String
    func noDataImageName() -> String?
    func noDataButtonTitle() -> String
}

extension ListViewModelProtocol {
    var filterModel: FilterModel {
        return FilterModel()
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .assetList:
            return viewModels[indexPath.row]
        case .facetList:
            guard let facetsViewModels = facetsViewModels, !facetsViewModels.isEmpty else { return nil }
            
            return facetsViewModels[indexPath.row]
        }
    }
    
    func model(at assetId: String) -> CellViewAnyModel? {
        switch assetType {
        case .program:
            if let viewModels = viewModels as? [ProgramTableViewCellViewModel], let i = viewModels.index(where: { $0.asset.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        case .fund:
            if let viewModels = viewModels as? [FundTableViewCellViewModel], let i = viewModels.index(where: { $0.asset.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        case .manager:
            if let viewModels = viewModels as? [ManagerTableViewCellViewModel], let i = viewModels.index(where: { $0.manager.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> BaseViewController? {
        switch assetType {
        case .program:
            guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
                return nil
            }
            
            let asset = model.asset
            guard let programId = asset.id else { return nil}
            guard let router = router as? Router else { return nil }
            
            return router.getProgramViewController(with: programId.uuidString)
        
        case .fund:
                guard let model = model(at: indexPath) as? FundTableViewCellViewModel else {
                    return nil
                }
                
                let asset = model.asset
                guard let fundId = asset.id else { return nil}
                guard let router = router as? Router else { return nil }
                
                return router.getFundViewController(with: fundId.uuidString)
        case .manager:
            guard let model = model(at: indexPath) as? ManagerTableViewCellViewModel else {
                return nil
            }
            
            let manager = model.manager
            guard let managerId = manager.id else { return nil}
            guard let router = router as? Router else { return nil }
            
            return router.getManagerViewController(with: managerId.uuidString)
        }
    }
    
    // MARK: - TableView
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        switch assetType {
        case .program:
            return [FacetsTableViewCellViewModel.self, ProgramTableViewCellViewModel.self]
        case .fund:
            return [FacetsTableViewCellViewModel.self, FundTableViewCellViewModel.self]
        case .manager:
            return [FacetsTableViewCellViewModel.self, ManagerTableViewCellViewModel.self]
        }
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        if filterModel.levelUpData != nil {
            return [RatingTableHeaderView.self]
        }
        
        return []
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .assetList:
            return modelsCount()
        case .facetList:
            guard let facetsCount = facetsViewModels?.count, facetsCount > 0, modelsCount() > 0 else { return 0 }
            return 1
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .assetList:
            return nil
        case .facetList:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .assetList:
            return 50.0
        case .facetList:
            return 50.0
        }
    }
    
    // MARK: - Navigation
    func showDetail(with assetId: String) {
        router.show(routeType: .showAssetDetails(assetId: assetId, assetType: assetType))
    }
    
    func showDetail(at indexPath: IndexPath) {
        switch assetType {
        case .program:
            showProgramDetail(at: indexPath)
        case .fund:
            showFundDetail(at: indexPath)
        case .manager:
            showManagerDetail(at: indexPath)
        }
    }
    
    func showProgramDetail(at indexPath: IndexPath) {
        guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let asset = model.asset
        guard let assetId = asset.id else { return }
        
        router.show(routeType: .showAssetDetails(assetId: assetId.uuidString, assetType: assetType))
    }
    
    func showFundDetail(at indexPath: IndexPath) {
        guard let model = model(at: indexPath) as? FundTableViewCellViewModel else { return }
        
        let asset = model.asset
        guard let assetId = asset.id else { return }
        
        router.show(routeType: .showAssetDetails(assetId: assetId.uuidString, assetType: assetType))
    }
    
    func showManagerDetail(at indexPath: IndexPath) {
        guard let model = model(at: indexPath) as? ManagerTableViewCellViewModel else { return }
        
        let manager = model.manager
        guard let assetId = manager.id else { return }
        
        router.show(routeType: .showAssetDetails(assetId: assetId.uuidString, assetType: assetType))
    }
    
    func showSignInVC() {
        router.show(routeType: .signIn)
    }
    
    func showFilterVC(filterType: FilterType, sortingType: SortingType) {
        router.show(routeType: .showFilterVC(listViewModel: self, filterModel: self.filterModel, filterType: filterType, sortingType: sortingType))
    }
    
    // MARK: - Nodata
    func logoImageName() -> String? {
        let imageName = "img_nodata_list"
        return imageName
    }
    
    func noDataText() -> String {
        return "There are no programs"
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Update"
        return text
    }
    
    // MARK: - Fetch
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Api.fetchThreshold == row && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    // MARK: - Private methods
    func responseHandler(_ viewModel: ProgramDetailsFull?, error: Error?, successCompletion: @escaping (_ programsViewModel: ProgramDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
}
