//
//  DashboardFundListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class DashboardFundListViewModel {
    
    enum SectionType {
        case fundList
    }
    
    // MARK: - Variables
    var title = "Funds"
    
    var sortingDelegateManager = SortingDelegateManager()
    var fundListDelegateManager: DashboardFundListDelegateManager!
    
    var activeFunds: Bool = true
    var highToLowValue: Bool = false
    
    private var sections: [SectionType] = [.fundList]
    
    private var router: DashboardRouter!
    private var fundList: FundsList?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dateRangeType: DateRangeType?
    var dateRangeFrom: Date?
    var dateRangeTo: Date?
    
    var canFetchMoreResults = true
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            title = totalCount > 0 ? "Funds \(totalCount)" : "Funds"
        }
    }
    
    var bottomViewType: BottomViewType {
        return .sort
    }
    
    var viewModels = [DashboardTableViewCellViewModel]() {
        didSet {
            self.activeViewModels = viewModels.filter { $0.fund?.status != .archived }
            self.archiveViewModels = viewModels.filter { $0.fund?.status == .archived }
        }
    }
    var activeViewModels = [DashboardTableViewCellViewModel]()
    var archiveViewModels = [DashboardTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        self.reloadDataProtocol = router.fundListViewController
        
        fundListDelegateManager = DashboardFundListDelegateManager(with: self)
        NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func changeFavorite(value: Bool, fundId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: fundId) as? DashboardTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.fund?.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
//        ProgramsDataProvider.programFavorites(isFavorite: !value, programId: programId) { [weak self] (result) in
//            switch result {
//            case .success:
//                guard let model = self?.model(at: programId) as? DashboardTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
//                model.fund?.personalDetails?.isFavorite = value
//                completion(.success)
//            case .failure(let errorType):
//                print(errorType)
//                completion(result)
//            }
//        }
    }
    
    // MARK: - Private methods
    @objc private func fundFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let fundId = notification.userInfo?["fundId"] as? String {
            changeFavorite(value: isFavorite, fundId: fundId) { [weak self] (result) in
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
        return [DashboardTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return activeFunds ? activeViewModels.count : archiveViewModels.count
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
        let imageName = "img_dashboard_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "you don’t have \nany funds yet.."
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse funds"
        return text.uppercased()
    }
    
    func showDetail(at indexPath: IndexPath) {
//        guard let model: DashboardTableViewCellViewModel = model(at: indexPath) as? DashboardTableViewCellViewModel else { return }
//
//        let fund = model.fund
//        guard let fundId = fund.id else { return }
//
//        router.show(routeType: .showFundDetails(fundId: fundId.uuidString))
    }
    
    func showFundList() {
//        router.show(routeType: .fundList)
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
            var allViewModels = self?.viewModels ?? [DashboardTableViewCellViewModel]()
            
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
        guard fundList != nil else {
            return nil
        }
        
        return activeFunds ? activeViewModels[indexPath.row] : archiveViewModels[indexPath.row]
    }
    
    func model(at fundId: String) -> CellViewAnyModel? {
        if activeFunds {
            if let i = activeViewModels.index(where: { $0.fund?.id?.uuidString == fundId }) {
                return activeViewModels[i]
            }
        } else {
            if let i = archiveViewModels.index(where: { $0.fund?.id?.uuidString == fundId }) {
                return archiveViewModels[i]
            }
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramViewController? {
//        guard let model = model(at: indexPath) as? DashboardTableViewCellViewModel else {
//            return nil
//        }
//
//        let fund = model.fund
//        guard let fundId = fund.id else { return nil}
//
//        return router.getDetailsViewController(with: fundId.uuidString)
        
        
        return nil
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [DashboardTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {

        DashboardDataProvider.getFundList(with: InvestorAPI.Sorting_v10InvestorFundsGet(rawValue: sortingDelegateManager.sorting.rawValue), completion: { [weak self] (fundsList) in
            guard let fundsList = fundsList else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            self?.fundList = fundsList
            
            var dashboardFundViewModels = [DashboardTableViewCellViewModel]()
            
            let totalCount = fundsList.funds?.count ?? 0
            
            fundsList.funds?.forEach({ (fund) in
                let dashboardTableViewCellModel = DashboardTableViewCellViewModel(program: nil, fund: fund, reloadDataProtocol: self?.router.fundListViewController, delegate:
                    self?.router.fundListViewController)
                dashboardFundViewModels.append(dashboardTableViewCellModel)
            })
            
            completionSuccess(totalCount, dashboardFundViewModels)
            completionError(.success)
            }, errorCompletion: completionError)
    }
}

