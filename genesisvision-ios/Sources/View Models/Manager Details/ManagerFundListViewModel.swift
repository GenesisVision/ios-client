//
//  ManagerFundListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 28/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ManagerFundListViewModel {
    
    enum SectionType {
        case fundList
    }
    
    // MARK: - Variables
    var activeFunds = true
    
    var managerId: String!
    var managerProfileDetails: ManagerProfileDetails?
    
    var title = "Funds"
    
    var sortingDelegateManager: SortingDelegateManager!
    var fundListDelegateManager: ManagerFundListDelegateManager!
    
    var highToLowValue: Bool = false
    
    private var sections: [SectionType] = [.fundList]
    
    private var router: ManagerFundListRouter!
    private var fundsList: FundsList?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var canFetchMoreResults = true
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            title = totalCount > 0 ? "Funds \(totalCount)" : "Funds"
        }
    }
    
    var bottomViewType: BottomViewType {
        return .dateRange
    }
    
    var viewModels = [FundTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ManagerFundListRouter, managerId: String) {
        self.router = router
        self.managerId = managerId
        self.reloadDataProtocol = router.managerFundsViewController
        
        sortingDelegateManager = SortingDelegateManager(.funds)
        fundListDelegateManager = ManagerFundListDelegateManager(with: self)
    }
    // MARK: - Public methods
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
    
    func hideHeader(value: Bool = true) {
        if let parentRouter = router.parentRouter, let managerRouter = parentRouter.parentRouter as? ManagerRouter {
            managerRouter.managerViewController.hideHeader(value)
        }
    }
}

// MARK: - TableView
extension ManagerFundListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
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
extension ManagerFundListViewModel {
    func logoImageName() -> String? {
        let imageName = "img_nodata_list"
        return imageName
    }
    
    func noDataText() -> String {
        return "manager don’t have \nany funds yet.."
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        return "Update"
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: FundTableViewCellViewModel = model(at: indexPath) as? FundTableViewCellViewModel else { return }
        
        let fund = model.fund
        guard let fundId = fund.id else { return }
        
        router.show(routeType: .showFundDetails(fundId: fundId.uuidString))
    }
}

// MARK: - Fetch
extension ManagerFundListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Constants.Api.fetchThreshold == row && canFetchMoreResults {
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
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard fundsList != nil else {
            return nil
        }
        
        return viewModels[indexPath.row]
    }
    
    func model(at fundId: String) -> CellViewAnyModel? {
        if let i = viewModels.index(where: { $0.fund.id?.uuidString == fundId }) {
            return viewModels[i]
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> FundViewController? {
        guard let model = model(at: indexPath) as? FundTableViewCellViewModel else {
            return nil
        }
        
        let fund = model.fund
        guard let fundId = fund.id else { return nil}
        
        return router.getFundDetailsViewController(with: fundId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [FundTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [FundTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        let sorting = sortingDelegateManager.sortingManager?.getSelectedSorting()
        let currencySecondary = FundsAPI.CurrencySecondary_v10FundsGet(rawValue: getSelectedCurrency()) ?? .btc
        
        FundsDataProvider.get(sorting: sorting as? FundsAPI.Sorting_v10FundsGet, currencySecondary: currencySecondary, statisticDateFrom: dateFrom, statisticDateTo: dateTo, chartPointsCount: nil, mask: nil, facetId: nil, isFavorite: nil, ids: nil, managerId: nil, programManagerId: nil, skip: skip, take: take, completion: { [weak self] (fundsList) in
            guard let fundsList = fundsList else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            self?.fundsList = fundsList
            
            var viewModels = [FundTableViewCellViewModel]()
            
            let totalCount = fundsList.total ?? 0
            
            fundsList.funds?.forEach({ (fund) in
                let fundTableViewCellViewModel = FundTableViewCellViewModel(fund: fund, delegate: nil)
                viewModels.append(fundTableViewCellViewModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
            }, errorCompletion: completionError)
    }
}

final class ManagerFundListDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: ManagerFundListViewModel?
    weak var delegate: DelegateManagerProtocol?
    
    init(with viewModel: ManagerFundListViewModel) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let modelsCount = viewModel?.modelsCount(), modelsCount >= indexPath.row else {
            return
        }
        
        viewModel?.showDetail(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.model(at: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        showInfiniteIndicator(value: viewModel?.fetchMore(at: indexPath.row))
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.delegateManagerScrollViewDidScroll(scrollView)
//        scrollView.isScrollEnabled = scrollView.contentOffset.y > -40.0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.delegateManagerScrollViewWillBeginDragging(scrollView)
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        if translation.y > 0 {
//            //            print("down")
//            scrollView.isScrollEnabled = scrollView.contentOffset.y > -40.0
//        } else {
//            //            print("up")
//            scrollView.isScrollEnabled = scrollView.contentOffset.y >= -40.0
//        }
    }
}

