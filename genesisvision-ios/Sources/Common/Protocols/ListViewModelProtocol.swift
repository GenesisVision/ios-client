//
//  ListViewModelProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

protocol ListViewModelProtocolWithFacets {
    var assetType: AssetType { get }
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }

    func didSelectFacet(at: IndexPath)
    func numberOfItems(in section: Int) -> Int
    func model(for indexPath: IndexPath) -> FacetCollectionViewCellViewModel?
}
extension ListViewModelProtocolWithFacets {
    func model(for indexPath: IndexPath) -> FacetCollectionViewCellViewModel? {
        return nil
    }
}

protocol BaseData {
    var title: String { get set }
    var type: CellActionType { get set }
}
extension BaseData {
    var title: String { return "" }
    var type: CellActionType { return .none }
}

// MARK: - ViewModelWithCollection
protocol CellViewModelWithCollection: BaseData, ViewModelWithListProtocol {
    func getRightButtons() -> [UIButton]
    func getLeftButtons() -> [UIButton]

    func getCollectionViewHeight() -> CGFloat
    func getTotalCount() -> Int?
    func hideLoader() -> Bool
}
extension CellViewModelWithCollection {
    func hideLoader() -> Bool {
        return !viewModels.isEmpty
    }
    func getTotalCount() -> Int? {
        return nil
    }
    func getLeftButtons() -> [UIButton] {
        return []
    }
    
    func getRightButtons() -> [UIButton] {
        return []
    }

    func getCollectionViewHeight() -> CGFloat {
        return 150.0
    }
}
protocol ViewModelWithFilter {
    var dateFrom: Date? { get set }
    var dateTo: Date? { get set }
}

// MARK: - ListViewModelProtocol
protocol ViewModelWithListProtocol {
    var viewModels: [CellViewAnyModel] { get set }
    var canPullToRefresh: Bool { get set }
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] { get }
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
    
    func fetch(completion: @escaping CompletionBlock)
    func fetch()
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel?
    func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    
    func modelsCount() -> Int
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    func headerView(_ tableView: UITableView, for section: Int) -> UIView?
    
    //CollectionView
    func insetForSection(for section: Int) -> UIEdgeInsets
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize
    func minimumLineSpacing(for section: Int) -> CGFloat
    func minimumInteritemSpacing(for section: Int) -> CGFloat
    
    func didSelect(at indexPath: IndexPath)
    func cellAnimations() -> Bool
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu?
}
extension ViewModelWithListProtocol {
    func cellAnimations() -> Bool {
        return false
    }
    
    var viewModels: [CellViewAnyModel] { return [] }
    var canPullToRefresh: Bool { return false }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] { return [] }
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] { return [] }
    
    func fetch(completion: @escaping CompletionBlock) {
        
    }
    func fetch() {
        
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }
    
    func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let model = model(for: indexPath) else {
            let cell = BaseTableViewCell()
            cell.loaderView.stopAnimating()
            cell.contentView.backgroundColor = UIColor.BaseView.bg
            cell.backgroundColor = UIColor.BaseView.bg
            return cell
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
    
    func headerView(_ tableView: UITableView, for section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.Cell.headerBg
        return view
    }
    
    func didSelect(at indexPath: IndexPath) {
        
    }
    
    
    //Collection View
    func insetForSection(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        return CGSize(width: frame.width * 0.75, height: frame.height - 16.0)
    }
    func minimumLineSpacing(for section: Int) -> CGFloat {
        return 16.0
    }
    func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return 16.0
    }
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu? {
        return nil
    }
}

protocol ListViewModelWithPaging: ViewModelWithListProtocol {
    var dataSource: TableViewDataSource { get }
    var canFetchMoreResults: Bool { get set }
    var skip: Int { get set }
    var totalCount: Int { get }
    func refresh()
    func take() -> Int
    func fetchMore(at indexPath: IndexPath)
    func fetch(_ refresh: Bool)
    func showInfiniteIndicator(_ value: Bool)
}

extension ListViewModelWithPaging {
    var totalCount: Int { return 0 }
    
    func take() -> Int { return ApiKeys.take }
    func fetchMore(at indexPath: IndexPath) {
        if modelsCount() - ApiKeys.fetchThreshold == indexPath.row && canFetchMoreResults && modelsCount() >= take() && modelsCount() < totalCount {
            fetch(false)
        }

        showInfiniteIndicator(skip < totalCount)
    }
    
    func refresh() {
        fetch(true)
    }
    
    
}

extension ListViewModelWithPaging {
    func showInfiniteIndicator(_ value: Bool) {
    }
    
    func fetch(_ refresh: Bool) {
    }
}
extension ListViewModelWithPaging where Self: ListViewController {
    func showInfiniteIndicator(_ value: Bool) {
        guard fetchMoreActivityIndicator != nil else { return }
        
        value ? fetchMoreActivityIndicator.startAnimating() : fetchMoreActivityIndicator.stopAnimating()
    }
}

// MARK: - Old ListViewModelProtocol
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
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel?
    func model(for assetId: String) -> CellViewAnyModel?
    func modelsCount() -> Int
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    
    func showDetail(with assetId: String)
    func showDetail(at indexPath: IndexPath)
    
    func fetchMore(at indexPath: IndexPath) -> Bool
    func fetchMore()
    
    func getDetailsViewController(with indexPath: IndexPath) -> UIViewController?
    func changeFavorite(value: Bool, assetId: String, request: Bool, completion: @escaping CompletionBlock)
    
    func logoImageName() -> String?
    func noDataText() -> String
    func noDataImageName() -> String?
    func noDataButtonTitle() -> String
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu?
}

extension ListViewModelProtocol {
    var filterModel: FilterModel {
        return FilterModel()
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .assetList:
            return viewModels[indexPath.row]
        case .facetList:
            guard let facetsViewModels = facetsViewModels, !facetsViewModels.isEmpty else { return nil }
            
            return facetsViewModels[indexPath.row]
        }
    }
    
    func model(for assetId: String) -> CellViewAnyModel? {
        switch assetType {
        case .program:
            if let viewModels = viewModels as? [ProgramTableViewCellViewModel], let i = viewModels.firstIndex(where: { $0.asset.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        case .follow:
            if let viewModels = viewModels as? [FollowTableViewCellViewModel], let i = viewModels.firstIndex(where: { $0.asset.id?.uuidString == assetId }) {
                return viewModels[i]
            }
            return nil
        case .fund:
            if let viewModels = viewModels as? [FundTableViewCellViewModel], let i = viewModels.firstIndex(where: { $0.asset.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        case ._none:
            //TODO: check it
            if let viewModels = viewModels as? [ManagerTableViewCellViewModel], let i = viewModels.firstIndex(where: { $0.profile.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> UIViewController? {
        switch assetType {
        case .program:
            guard let model = model(for: indexPath) as? ProgramTableViewCellViewModel,
                let assetId = model.asset.id?.uuidString,
                let router = router as? Router
                else { return nil }
            
            return router.getProgramViewController(with: assetId, assetType: .program)
        case .follow:
            guard let model = model(for: indexPath) as? FollowTableViewCellViewModel,
                let assetId = model.asset.id?.uuidString,
                let router = router as? Router
                else { return nil }
                
            return router.getProgramViewController(with: assetId, assetType: .follow)
        case .fund:
            guard let model = model(for: indexPath) as? FundTableViewCellViewModel,
                let assetId = model.asset.id?.uuidString,
                let router = router as? Router
                else { return nil }
            
            return router.getFundViewController(with: assetId)
        case ._none:
            guard let model = model(for: indexPath) as? ManagerTableViewCellViewModel,
                let managerId = model.profile.id?.uuidString,
                let router = router as? Router
                else { return nil }
        
            return router.getManagerViewController(with: managerId)
        }
    }
    
    // MARK: - TableView
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        switch assetType {
        case .program:
            return [FacetsTableViewCellViewModel.self, ProgramTableViewCellViewModel.self]
        case .follow:
            return [FacetsTableViewCellViewModel.self, FollowTableViewCellViewModel.self]
        case .fund:
            return [FacetsTableViewCellViewModel.self, FundTableViewCellViewModel.self]
        case ._none:
            return [FacetsTableViewCellViewModel.self, ManagerTableViewCellViewModel.self]
        }
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        if filterModel.facetTitle == "Rating" {
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
        case .follow: 
            showFollowDetail(at: indexPath)
        case .fund:
            showFundDetail(at: indexPath)
        case ._none:
            showManagerDetail(at: indexPath)
        }
    }
    
    func showProgramDetail(at indexPath: IndexPath) {
        guard let model = model(for: indexPath) as? ProgramTableViewCellViewModel, let assetId = model.asset.id?.uuidString else { return }
        
        router.show(routeType: .showAssetDetails(assetId: assetId, assetType: assetType))
    }
    
    func showFollowDetail(at indexPath: IndexPath) {
        guard let model = model(for: indexPath) as? FollowTableViewCellViewModel, let assetId = model.asset.id?.uuidString else { return }

        router.show(routeType: .showAssetDetails(assetId: assetId, assetType: assetType))
    }
    
    func showFundDetail(at indexPath: IndexPath) {
        guard let model = model(for: indexPath) as? FundTableViewCellViewModel, let assetId = model.asset.id?.uuidString else { return }
        
        router.show(routeType: .showAssetDetails(assetId: assetId, assetType: assetType))
    }
    
    func showManagerDetail(at indexPath: IndexPath) {
        guard let model = model(for: indexPath) as? ManagerTableViewCellViewModel else { return }
        
        let manager = model.profile
        guard let assetId = manager.id else { return }
        
        router.show(routeType: .showAssetDetails(assetId: assetId.uuidString, assetType: assetType))
    }
    
    func showSignInVC() {
        router.show(routeType: .signIn)
    }
    
    func showFilterVC(listViewModel: ListViewModelProtocol, filterModel: FilterModel, filterType: FilterType, sortingType: SortingType) {
        router.show(routeType: .showFilterVC(listViewModel: listViewModel, filterModel: filterModel, filterType: filterType, sortingType: sortingType))
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
    func fetchMore(at indexPath: IndexPath) -> Bool {
        if modelsCount() - ApiKeys.fetchThreshold == indexPath.row && canFetchMoreResults && modelsCount() >= take {
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
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu? {
        return nil
    }
}
