//
//  FavoriteProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

final class FavoriteProgramListViewModel: ListViewModelProtocol {
    var type: ListType = .programList
    
   // MARK: - Variables
    var title: String = "Favorite programs"

    internal var sections: [SectionType] = [.assetList]
    
    var router: ListRouterProtocol!
    
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var sortingDelegateManager: SortingDelegateManager!
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var mask: String?
    var isFavorite: Bool = false
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var count: String = ""
    var chartPointsCount = Constants.Api.equityChartLength
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            count = "\(totalCount) programs"
        }
    }
    
    var headerTitle = "PROGRAMS"
    
    var bottomViewType: BottomViewType {
        return .sort
    }
    
    public private(set) var needToRefresh = false
    
    internal var sorting: ProgramsAPI.Sorting_v10ProgramsGet = Constants.Sorting.programListDefault
    
    var searchText = "" {
        didSet {
            mask = searchText
        }
    }
    var viewModels = [CellViewAnyModel]()
    
    var sortingKeys: [ProgramsAPI.Sorting_v10ProgramsGet] = [.byProfitDesc, .byProfitAsc,
                                                           .byLevelDesc, .byLevelAsc,
                                                           .byBalanceDesc, .byBalanceDesc,
                                                           .byTradesDesc, .byTradesAsc,
                                                           .byEndOfPeriodDesc, .byEndOfPeriodAsc,
                                                           .byTitleDesc, .byTitleAsc]
    
    var sortingValues: [String] = ["profit ⇣", "profit ⇡",
                                   "level ⇣", "level ⇡",
                                   "balance ⇣", "balance ⇡",
                                   "orders ⇣", "orders ⇡",
                                   "end of period ⇣",
                                   "end of period ⇡",
                                   "title ⇣", "title ⇡"]
    
    struct SortingList {
        var sortingValue: String
        var sortingKey: ProgramsAPI.Sorting_v10ProgramsGet
    }
    
    var sortingList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingKeys[index])
        }
    }
    
    // MARK: - Init
    init(withRouter router: FavoriteProgramListRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        
        sortingDelegateManager = SortingDelegateManager(.programs)
        NotificationCenter.default.addObserver(self, selector: #selector(programFavoriteStateChangeNotification(notification:)), name: .programFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.program.personalDetails?.isFavorite = value
            
            if var viewModels = viewModels as? [ProgramTableViewCellViewModel], !value, let i = viewModels.index(where: { $0.program.id?.uuidString == assetId }) {
                viewModels.remove(at: i)
                totalCount = viewModels.count
            }
            
            completion(.success)
            return
        }
        
        ProgramsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.program.personalDetails?.isFavorite = value
                value ? completion(.success) : self?.refresh(completion: completion)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    // MARK: - Private methods
    @objc private func programFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite: Bool = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["programId"] as? String {
            
            guard !isFavorite else {
                refresh { [weak self] (result) in
                    self?.reloadDataProtocol?.didReloadData()
                }
                
                return
            }
            
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
}

// MARK: - Fetch
extension FavoriteProgramListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalProgramCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Constants.Api.fetchThreshold == row && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [ProgramTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalProgramCount: totalCount, allViewModels as! [ProgramTableViewCellViewModel])
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
        needToRefresh = false
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalProgramCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    private func updateFetchedData(totalProgramCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalProgramCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }

    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            ProgramsDataProvider.get(isFavorite: true, skip: skip, take: take, completion: { (programsViewModel) in
                guard let programs = programsViewModel else { return completionError(.failure(errorType: .apiError(message: nil))) }
                
                var viewModels = [ProgramTableViewCellViewModel]()
                
                let totalCount = programs.total ?? 0
                
                programs.programs?.forEach({ [weak self] (program) in
                    guard let favoriteProgramListRouter: FavoriteProgramListRouter = self?.router as? FavoriteProgramListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let programTableViewCellViewModel = ProgramTableViewCellViewModel(program: program, delegate: favoriteProgramListRouter.favoriteProgramListViewController)
                    viewModels.append(programTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            break
        }
    }
}
