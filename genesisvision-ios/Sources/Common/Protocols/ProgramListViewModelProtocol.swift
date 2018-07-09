//
//  ProgramListViewModelProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

enum SectionType {
    case header
    case programList
}

protocol ProgramListViewModelProtocol {
    var router: ProgramListRouterProtocol! { get }
    var searchText: String { get set }
    var title: String { get }
    var sortingValues: [String] { get }
    var sections: [SectionType] { get }
    var bottomViewType: BottomViewType { get } 
    
    var programViewModels: [ProgramTableViewCellViewModel] { get set }
    
    var canFetchMoreResults: Bool { get set }
    var dataType: DataType { get }
    var programsCount: String { get }
    var equityChartLength: Int { get }
    
    var headerTitle: String { get }
    
    var skip: Int { get set }
    var take: Int { get set }
    var totalCount: Int { get set }
    
    var filter: InvestmentProgramsFilter? { get }
    var sorting: InvestmentProgramsFilter.Sorting { get }
    var sortingKeys: [InvestmentProgramsFilter.Sorting] { get }
    
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] { get }
    static var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
    
    func getSelectedSortingIndex() -> Int
    func refresh(completion: @escaping CompletionBlock)
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel?
    func model(at investmentProgramId: String) -> CellViewAnyModel?
    func modelsCount() -> Int
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func sortTitle() -> String?
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    
    func showDetail(with investmentProgramId: String)
    func showDetail(at indexPath: IndexPath)
    
    func fetch(completion: @escaping CompletionBlock)
    func fetchMore(at row: Int) -> Bool
    func fetchMore()
    func changeSorting(at index: Int)
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramDetailsTabmanViewController?
    func changeFavorite(value: Bool, investmentProgramId: String, request: Bool, completion: @escaping CompletionBlock)
    
    func logoImageName() -> String?
    func noDataText() -> String
    func noDataImageName() -> String?
    func noDataButtonTitle() -> String
}

extension ProgramListViewModelProtocol {
    func getSelectedSortingIndex() -> Int {
        guard let sorting = filter?.sorting else { return 0 }
        
        return sortingKeys.index(of: sorting) ?? 0
    }
    
    func getSortingValue(sortingKey: InvestmentProgramsFilter.Sorting) -> String {
        guard let index = sortingKeys.index(of: sortingKey) else { return "" }
        return sortingValues[index]
    }
    
    func getSortingValue(at index: Int) {
        filter?.sorting = sortingKeys[index]
    }
    
    func changeSorting(at index: Int) {
        filter?.sorting = sortingKeys[index]
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return ProgramListHeaderTableViewCellViewModel(title: headerTitle, programListCount: totalCount)
        case .programList:
            return programViewModels[indexPath.row]
        }
    }
    
    func model(at investmentProgramId: String) -> CellViewAnyModel? {
        if let i = programViewModels.index(where: { $0.investmentProgram.id?.uuidString == investmentProgramId }) {
            return programViewModels[i]
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramDetailsTabmanViewController? {
        guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
            return nil
        }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return nil}
        
        guard let router: Router = router as? Router else { return nil }
        
        return router.getDetailsViewController(with: investmentProgramId.uuidString)
    }
    
    // MARK: - TableView
    func sortTitle() -> String? {
        guard let sort = filter?.sorting else { return "Sort by " }
        
        return "Sort by " + getSortingValue(sortingKey: sort)
    }
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramListHeaderTableViewCellViewModel.self, ProgramTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [SortHeaderView.self]
    }
    
    func modelsCount() -> Int {
        return programViewModels.count
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
    
    // MARK: - Navigation
    func showDetail(with investmentProgramId: String) {
        router.show(routeType: .showProgramDetails(investmentProgramId: investmentProgramId))
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: ProgramTableViewCellViewModel = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return }
        
        router.show(routeType: .showProgramDetails(investmentProgramId: investmentProgramId.uuidString))
    }
    
    func showSignInVC() {
        if let router = router as? InvestmentProgramListRouter {
            router.show(routeType: .signIn)
        }
    }
    
    func showFilterVC() {
        if let router = router as? InvestmentProgramListRouter, (self as? InvestmentProgramListViewModel) != nil {
            router.show(routeType: .showFilterVC(investmentProgramListViewModel: self as! InvestmentProgramListViewModel))
        }
    }
    
    func showTournamentVC() {
        guard let platformStatus = PlatformManager.platformStatus, let tournamentTotalRounds = platformStatus.tournamentTotalRounds, let tournamentCurrentRound = platformStatus.tournamentCurrentRound else { return }
        
        if let router = router as? InvestmentProgramListRouter {
            router.show(routeType: .showTournamentVC(tournamentTotalRounds: tournamentTotalRounds, tournamentCurrentRound: tournamentCurrentRound))
        }
    }
    
    // MARK: - Nodata
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
    
    // MARK: - Fetch
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Constants.Api.fetchThreshold == row && canFetchMoreResults {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    // MARK: - Private methods
    func responseHandler(_ viewModel: InvestmentProgramsViewModel?, error: Error?, successCompletion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    func fakeViewModels(completion: (_ traderCellModels: [ProgramTableViewCellViewModel]) -> Void) {
        completion([ProgramTableViewCellViewModel]())
    }
}


