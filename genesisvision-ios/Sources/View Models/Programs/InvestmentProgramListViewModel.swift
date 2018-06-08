//
//  InvestmentProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

enum InvestmentProgramListViewState {
    case programList, programListWithSignIn
}

final class InvestmentProgramListViewModel {
    
    enum SectionType {
        case header
        case programList
    }
    
    // MARK: - Variables
    var title: String = "Programs"
    var roundNumber: Int = 1
    private var sections: [SectionType] = [.header, .programList]
    
    var router: InvestmentProgramListRouter!
    var state: InvestmentProgramListViewState?
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

    var filter: InvestmentProgramsFilter?
    private var sorting: InvestmentProgramsFilter.Sorting = Constants.Sorting.programListDefault
    var searchText = "" {
        didSet {
            filter?.name = searchText
        }
    }
    var investmentProgramViewModels = [ProgramTableViewCellViewModel]()
    
    var sortingKeys: [InvestmentProgramsFilter.Sorting] = [.byProfitDesc, .byProfitAsc,
                                                           .byLevelDesc, .byLevelAsc,
                                                           .byBalanceDesc, .byBalanceDesc,
                                                           .byOrdersDesc, .byOrdersAsc,
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
        var sortingKey: InvestmentProgramsFilter.Sorting
    }
    
    var sortingList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingKeys[index])
        }
    }
    
    // MARK: - Init
    init(withRouter router: InvestmentProgramListRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        
        filter = InvestmentProgramsFilter(managerId: nil,
                                          brokerId: nil,
                                          brokerTradeServerId: nil,
                                          investMaxAmountFrom: nil,
                                          investMaxAmountTo: nil,
                                          sorting: sorting,
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
    }
    
    // MARK: - Public methods
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    func signInButtonEnable() -> Bool {
        return state == .programListWithSignIn
    }
    
    func getSortingValue(sortingKey: InvestmentProgramsFilter.Sorting) -> String {
        guard let index = sortingKeys.index(of: sortingKey) else { return "" }
        return sortingValues[index]
    }
    
    func changeSorting(at index: Int) {
        filter?.sorting = sortingKeys[index]
    }
    
    func getSelectedSortingIndex() -> Int {
        guard let sorting = filter?.sorting else { return 0 }
        
        return sortingKeys.index(of: sorting) ?? 0
    }
    
    func changeFavorite(value: Bool, investmentProgramId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: investmentProgramId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.investmentProgram.isFavorite = value
            completion(.success)
            return
        }
        
        
        ProgramDataProvider.programFavorites(isFavorite: !value, investmentProgramId: investmentProgramId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: investmentProgramId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.investmentProgram.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
}

// MARK: - TableView
extension InvestmentProgramListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramListHeaderTableViewCellViewModel.self, ProgramTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [SortHeaderView.self]
    }
    
    func modelsCount() -> Int {
        return investmentProgramViewModels.count
    }

    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .programList:
            return modelsCount()
        case .header:
            return 1
        }
    }
    
    func sortTitle() -> String? {
        guard let sort = filter?.sorting else { return "Sort by " }
        
        return "Sort by " + getSortingValue(sortingKey: sort)
    }
        
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .programList:
            return nil
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .programList:
            return 50.0
        case .header:
            return 0.0
        }
    }
}

// MARK: - Navigation
extension InvestmentProgramListViewModel {
    // MARK: - Public methods
    func showSignInVC() {
        router.show(routeType: .signIn)
    }
    
    func showFilterVC() {
        router.show(routeType: .showFilterVC(investmentProgramListViewModel: self))
    }
    
    func showTournamentVC() {
        guard let platformStatus = PlatformManager.platformStatus, let tournamentTotalRounds = platformStatus.tournamentTotalRounds, let tournamentCurrentRound = platformStatus.tournamentCurrentRound else { return }
        
        router.show(routeType: .showTournamentVC(tournamentTotalRounds: tournamentTotalRounds, tournamentCurrentRound: tournamentCurrentRound))
    }
    
    func showDetail(with investmentProgramId: String) {
        router.show(routeType: .showProgramDetails(investmentProgramId: investmentProgramId))
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: ProgramTableViewCellViewModel = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return }
        
        router.show(routeType: .showProgramDetails(investmentProgramId: investmentProgramId.uuidString))
    }
}

// MARK: - Fetch
extension InvestmentProgramListViewModel {
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
            var allViewModels = self?.investmentProgramViewModels ?? [ProgramTableViewCellViewModel]()
            
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
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return ProgramListHeaderTableViewCellViewModel(programListCount: totalCount)
        case .programList:
            return investmentProgramViewModels[indexPath.row]
        }
    }
    
    func model(at investmentProgramId: String) -> CellViewAnyModel? {
        if let i = investmentProgramViewModels.index(where: { $0.investmentProgram.id?.uuidString == investmentProgramId }) {
            return investmentProgramViewModels[i]
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramDetailsTabmanViewController? {
        guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
            return nil
        }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return nil}
        
        return router.getDetailsViewController(with: investmentProgramId.uuidString)
    }
    
    // MARK: - Private methods
    private func responseHandler(_ viewModel: InvestmentProgramsViewModel?, error: Error?, successCompletion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    private func fakeViewModels(completion: (_ traderCellModels: [ProgramTableViewCellViewModel]) -> Void) {    
        completion([ProgramTableViewCellViewModel]())
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) {
        self.investmentProgramViewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let filter = filter else { return completionError(.failure(errorType: .apiError(message: nil))) }
            ProgramDataProvider.getPrograms(with: filter, completion: { [weak self] (investmentProgramsViewModel) in
                guard let investmentPrograms = investmentProgramsViewModel else { return completionError(.failure(errorType: .apiError(message: nil))) }
                
                var investmentProgramViewModels = [ProgramTableViewCellViewModel]()
                
                let totalCount = investmentPrograms.total ?? 0
                
                investmentPrograms.investmentPrograms?.forEach({ (investmentProgram) in
                    let programTableViewCellViewModel = ProgramTableViewCellViewModel(investmentProgram: investmentProgram, delegate: self?.router.programsViewController)
                    investmentProgramViewModels.append(programTableViewCellViewModel)
                })
                
                completionSuccess(totalCount, investmentProgramViewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            fakeViewModels { (investmentProgramViewModels) in
                completionSuccess(investmentProgramViewModels.count, investmentProgramViewModels)
                completionError(.success)
            }
        }
    }
}

extension InvestmentProgramListViewModel {
    func logoImageName() -> String? {
        let imageName = "img_program_list_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "no programs yet"
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "update".uppercased()
        return text
    }
}
