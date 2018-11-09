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
    
    // MARK: - Variables
    var type: ListType = .fundList
    var title: String = "Funds"
    var roundNumber: Int = 1
    
    var sortingDelegateManager: SortingDelegateManager!
    
    internal var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    var state: FundListViewState?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var count: String = ""
    var chartPointsCount = Api.equityChartLength
    var skip = 0
    var take = Api.take
    var totalCount = 0 {
        didSet {
            count = "\(totalCount) funds"
        }
    }

    var mask: String?
    var isFavorite: Bool = false
    
    private var fundsList: FundsList?

    var dateFrom: Date?
    var dateTo: Date?
    
    var bottomViewType: BottomViewType {
        return signInButtonEnable ? .signIn : .filter
    }
    
    var searchText = "" {
        didSet {
            mask = searchText
        }
    }
    var viewModels = [CellViewAnyModel]()
    
    // MARK: - Init
    init(withRouter router: FundListRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        
        state = isLogin() ? .fundList : .fundListWithSignIn
        sortingDelegateManager = SortingDelegateManager(.funds)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fundFavoriteStateChangeNotification(notification:)), name: .fundFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fundFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func noDataText() -> String {
        return "You do not have any funds yet"
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
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalFundCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
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

            self?.updateFetchedData(totalFundCount: totalCount, allViewModels as! [FundTableViewCellViewModel])
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
            self?.updateFetchedData(totalFundCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    private func updateFetchedData(totalFundCount: Int, _ viewModels: [FundTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalFundCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }

    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [FundTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            
            let sorting = sortingDelegateManager.sortingManager?.getSelectedSorting()
            let currencySecondary = FundsAPI.CurrencySecondary_v10FundsGet(rawValue: getSelectedCurrency()) ?? .btc
            
            FundsDataProvider.get(sorting: sorting as? FundsAPI.Sorting_v10FundsGet, currencySecondary: currencySecondary, statisticDateFrom: dateFrom, statisticDateTo: dateTo, chartPointsCount: nil, mask: nil, facetId: nil, isFavorite: nil, ids: nil, managerId: nil, programManagerId: nil, skip: skip, take: take, completion: { [weak self] (fundsList) in
                guard let fundsList = fundsList else { return completionError(.failure(errorType: .apiError(message: nil))) }
                print(fundsList)
                self?.fundsList = fundsList
                
                var viewModels = [FundTableViewCellViewModel]()
                
                let totalCount = fundsList.total ?? 0
                
                fundsList.funds?.forEach({ (fund) in
                    guard let fundListRouter: FundListRouter = self?.router as? FundListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let fundTableViewCellViewModel = FundTableViewCellViewModel(fund: fund, delegate: fundListRouter.fundsViewController)
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
