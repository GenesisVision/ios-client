//
//  ProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramListViewState {
    case programList, programListWithSignIn
}

struct ProgramsFilter {
    public enum ProfitTotalChange: String, Codable {
        case unchanged = "Unchanged"
        case up = "Up"
        case down = "Down"
    }
    
    var managerId: UUID?
    var brokerId: UUID?
    var brokerTradeServerId: UUID?
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    var sorting: ProgramsAPI.Sorting_v10ProgramsGet?
    var name: String?
    var levelMin: Int?
    var levelMax: Int?
    var balanceUsdMin: Double?
    var balanceUsdMax: Double?
    var profitAvgMin: Double?
    var profitAvgMax: Double?
    var profitTotalMin: Double?
    var profitTotalMax: Double?
    var profitTotalPercentMin: Double?
    var profitTotalPercentMax: Double?
    var profitAvgPercentMin: Double?
    var profitAvgPercentMax: Double?
    var profitTotalChange: ProfitTotalChange?
    var periodMin: Int?
    var periodMax: Int?
    var showActivePrograms: Bool?
    var equityChartLength: Int?
    var showMyFavorites: Bool?
    var roundNumber: Int?
    var skip: Int?
    var take: Int?

}

final class ProgramListViewModel: ProgramListViewModelProtocol {
    
    // MARK: - Variables
    var title: String = "Programs"
    var roundNumber: Int = 1
    
    var sortingDelegateManager = SortingDelegateManager()
    
    internal var sections: [SectionType] = [.programList]
    
    var router: ProgramListRouterProtocol!
    var state: ProgramListViewState?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var programsCount: String = ""
    var equityChartLength = Constants.Api.equityChartLength
    var skip = 0 {
        didSet {
            filter?.skip = skip
        }
    }
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }

    var highToLowValue: Bool = false
    
    var dateRangeType: DateRangeType = .day {
        didSet {
            switch dateRangeType {
            case .custom:
                dateRangeTo.setTime(hour: 0, min: 0, sec: 0)
                dateRangeFrom.setTime(hour: 23, min: 59, sec: 59)
            default:
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: dateRangeTo)
                let min = calendar.component(.minute, from: dateRangeTo)
                let sec = calendar.component(.second, from: dateRangeTo)
                dateRangeFrom.setTime(hour: hour, min: min, sec: sec)
            }
        }
    }
    var dateRangeFrom: Date = Date().previousDate()
    var dateRangeTo: Date = Date()
    
    var headerTitle = "PROGRAMS TO INVEST IN"
    var bottomViewType: BottomViewType {
        return signInButtonEnable ? .signInWithFilter : .filter
    }
    
    var filter: ProgramsFilter?
    
    var searchText = "" {
        didSet {
            filter?.name = searchText
        }
    }
    var programViewModels: [ProgramTableViewCellViewModel] = [ProgramTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ProgramListRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        
        filter = ProgramsFilter(managerId: nil,
                                brokerId: nil,
                                brokerTradeServerId: nil,
                                investMaxAmountFrom: nil,
                                investMaxAmountTo: nil,
                                sorting: nil,//TODO: sortingDelegateManager.sorting,
                                name: searchText,
                                levelMin: nil,
                                levelMax: nil,
                                balanceUsdMin: nil,
                                balanceUsdMax: nil,
                                profitAvgMin: nil,
                                profitAvgMax: nil,
                                profitTotalMin: nil,
                                profitTotalMax: nil,
                                profitTotalPercentMin: nil,
                                profitTotalPercentMax: nil,
                                profitAvgPercentMin: nil,
                                profitAvgPercentMax: nil,
                                profitTotalChange: nil,
                                periodMin: nil,
                                periodMax: nil,
                                showActivePrograms: nil,
                                equityChartLength: equityChartLength,
                                showMyFavorites: nil,
                                roundNumber: nil,
                                skip: skip,
                                take: take)

        state = isLogin() ? .programList : .programListWithSignIn
        
        NotificationCenter.default.addObserver(self, selector: #selector(programFavoriteStateChangeNotification(notification:)), name: .programFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    var signInButtonEnable: Bool {
        return state == .programListWithSignIn
    }
    
    func changeFavorite(value: Bool, programId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: programId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.program.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        
        ProgramDataProvider.programFavorites(isFavorite: !value, programId: programId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: programId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.program.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    // MARK: - Private methods
    @objc private func programFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let programId = notification.userInfo?["programId"] as? String {
            changeFavorite(value: isFavorite, programId: programId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
}

// MARK: - Fetch
extension ProgramListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalProgramCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }

        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.programViewModels ?? [ProgramTableViewCellViewModel]()

            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })

            self?.updateFetchedData(totalProgramCount: totalCount, allViewModels)
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
            self?.updateFetchedData(totalProgramCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    private func updateFetchedData(totalProgramCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) {
        self.programViewModels = viewModels
        self.totalCount = totalProgramCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }

    // MARK: - Private methods
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            ProgramDataProvider.getPrograms(with: nil, levelMax: nil, profitAvgMin: nil, profitAvgMax: nil, sorting: nil, programCurrency: nil, currencySecondary: nil, statisticDateFrom: nil, statisticDateTo: nil, chartPointsCount: nil, mask: nil, facetId: nil, isFavorite: nil, ids: nil, skip: nil, take: nil, completion: { [weak self] (programsViewModel) in
                guard let programs = programsViewModel else { return completionError(.failure(errorType: .apiError(message: nil))) }
                
                var programViewModels = [ProgramTableViewCellViewModel]()
                
                let totalCount = programs.total ?? 0
                
                programs.programs?.forEach({ (program) in
                    guard let programListRouter: ProgramListRouter = self?.router as? ProgramListRouter else { return completionError(.failure(errorType: .apiError(message: nil))) }
                    
                    let programTableViewCellViewModel = ProgramTableViewCellViewModel(program: program, delegate: programListRouter.programsViewController)
                    programViewModels.append(programTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, programViewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            fakeViewModels { (programViewModels) in
                completionSuccess(programViewModels.count, programViewModels)
                completionError(.success)
            }
        }
    }
}
