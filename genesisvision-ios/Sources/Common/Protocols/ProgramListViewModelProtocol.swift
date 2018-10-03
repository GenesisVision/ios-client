//
//  ProgramListViewModelProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

protocol ProgramListViewModelProtocol {
    var router: ProgramListRouterProtocol! { get }
    var searchText: String { get set }
    var title: String { get }

    var sortingDelegateManager: SortingDelegateManager { get }
    
    var sections: [SectionType] { get }
    var bottomViewType: BottomViewType { get } 
    
    var programViewModels: [ProgramTableViewCellViewModel] { get set }
    
    var canFetchMoreResults: Bool { get set }
    var dataType: DataType { get }
    var programsCount: String { get }
    var equityChartLength: Int { get }
    
    var headerTitle: String { get }
    
    var highToLowValue: Bool { get set }
    var dateRangeType: DateRangeType { get set }
    var dateRangeFrom: Date { get set }
    var dateRangeTo: Date { get set }
    
    var skip: Int { get set }
    var take: Int { get set }
    var totalCount: Int { get set }
    
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] { get }
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
    
    func refresh(completion: @escaping CompletionBlock)
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel?
    func model(at programId: String) -> CellViewAnyModel?
    func modelsCount() -> Int
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    
    func showDetail(with programId: String)
    func showDetail(at indexPath: IndexPath)
    
    func fetch(completion: @escaping CompletionBlock)
    func fetchMore(at row: Int) -> Bool
    func fetchMore()
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramViewController?
    func changeFavorite(value: Bool, programId: String, request: Bool, completion: @escaping CompletionBlock)
    
    func logoImageName() -> String?
    func noDataText() -> String
    func noDataImageName() -> String?
    func noDataButtonTitle() -> String
}

extension ProgramListViewModelProtocol {
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
    
    func model(at programId: String) -> CellViewAnyModel? {
        if let i = programViewModels.index(where: { $0.program.id?.uuidString == programId }) {
            return programViewModels[i]
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramViewController? {
        guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
            return nil
        }
        
        let program = model.program
        guard let programId = program.id else { return nil}
        
        guard let router: Router = router as? Router else { return nil }
        
        return router.getDetailsViewController(with: programId.uuidString)
    }
    
    // MARK: - TableView
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramListHeaderTableViewCellViewModel.self, ProgramTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
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
    func showDetail(with programId: String) {
        router.show(routeType: .showProgramDetails(programId: programId))
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: ProgramTableViewCellViewModel = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let program = model.program
        guard let programId = program.id else { return }
        
        router.show(routeType: .showProgramDetails(programId: programId.uuidString))
    }
    
    func showSignInVC() {
        if let router = router as? ProgramListRouter {
            router.show(routeType: .signIn)
        }
    }
    
    func showFilterVC() {
        if let router = router as? ProgramListRouter, (self as? ProgramListViewModel) != nil {
            router.show(routeType: .showFilterVC(programListViewModel: self as! ProgramListViewModel))
        }
    }
    
    func showTournamentVC() {
//        guard let platformInfo = PlatformManager.platformInfo, let tournamentTotalRounds = platformStatus.tournamentTotalRounds, let tournamentCurrentRound = platformInfo.tournamentCurrentRound else { return }
//
//        if let router = router as? ProgramListRouter {
//            router.show(routeType: .showTournamentVC(tournamentTotalRounds: tournamentTotalRounds, tournamentCurrentRound: tournamentCurrentRound))
//        }
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
    func responseHandler(_ viewModel: ProgramDetailsFull?, error: Error?, successCompletion: @escaping (_ programsViewModel: ProgramDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    func fakeViewModels(completion: (_ traderCellModels: [ProgramTableViewCellViewModel]) -> Void) {
        completion([ProgramTableViewCellViewModel]())
    }
}


