//
//  ListViewModelProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView
enum ListType {
    case programList
    case fundList
}
protocol ListViewModelProtocol {
    var router: ListRouterProtocol! { get }
    
    var type: ListType { get }
    
    var searchText: String { get set }
    var title: String { get }

    var sortingDelegateManager: SortingDelegateManager { get }
    
    var sections: [SectionType] { get }
    var bottomViewType: BottomViewType { get } 
    
    var viewModels: [CellViewAnyModel] { get set }
    
    var canFetchMoreResults: Bool { get set }
    var dataType: DataType { get }
    var count: String { get }
    var equityChartLength: Int { get }
    
    var headerTitle: String { get }
    
    var highToLowValue: Bool { get set }
    var dateRangeType: DateRangeType { get set }
    var dateRangeFrom: Date { get set }
    var dateRangeTo: Date { get set }
    
    var skip: Int { get set }
    var take: Int { get set }
    var totalCount: Int { get set }
    
    var filter: ProgramsFilter? { get }
    
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
    
    func fetch(completion: @escaping CompletionBlock)
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
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .assetList:
            return viewModels[indexPath.row]
        }
    }
    
    func model(at assetId: String) -> CellViewAnyModel? {
        switch type {
        case .programList:
            if let viewModels = viewModels as? [ProgramTableViewCellViewModel], let i = viewModels.index(where: { $0.program.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        case .fundList:
            if let viewModels = viewModels as? [FundTableViewCellViewModel], let i = viewModels.index(where: { $0.fund.id?.uuidString == assetId }) {
                return viewModels[i]
            }
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> BaseViewController? {
        switch type {
        case .programList:
            guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
                return nil
            }
            
            let program = model.program
            guard let programId = program.id else { return nil}
            guard let router = router as? Router else { return nil }
            
            return router.getDetailsViewController(with: programId.uuidString)
        
        case .fundList:
                guard let model = model(at: indexPath) as? FundTableViewCellViewModel else {
                    return nil
                }
                
                let fund = model.fund
                guard let fundId = fund.id else { return nil}
                guard let router = router as? Router else { return nil }
                
                return router.getFundDetailsViewController(with: fundId.uuidString)
        }
        
        return nil
    }
    
    // MARK: - TableView
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        switch type {
        case .programList:
            return [ProgramTableViewCellViewModel.self]
        case .fundList:
            return [FundTableViewCellViewModel.self]
        }
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [SortHeaderView.self]
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
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .assetList:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .assetList:
            return 50.0
        }
    }
    
    // MARK: - Navigation
    func showDetail(with assetId: String) {
        switch type {
        case .programList:
            router.show(routeType: .showProgramDetails(programId: assetId))
        case .fundList:
            router.show(routeType: .showFundDetails(fundId: assetId))
        }
    }
    
    func showDetail(at indexPath: IndexPath) {
        switch type {
        case .programList:
            showProgramDetail(at: indexPath)
        case .fundList:
            showFundDetail(at: indexPath)
        }
    }
    
    func showProgramDetail(at indexPath: IndexPath) {
        guard let model: ProgramTableViewCellViewModel = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let program = model.program
        guard let programId = program.id else { return }
        
        router.show(routeType: .showProgramDetails(programId: programId.uuidString))
    }
    
    func showFundDetail(at indexPath: IndexPath) {
        guard let model: FundTableViewCellViewModel = model(at: indexPath) as? FundTableViewCellViewModel else { return }
        
        let fund = model.fund
        guard let fundId = fund.id else { return }
        
        router.show(routeType: .showFundDetails(fundId: fundId.uuidString))
    }
    
    func showSignInVC() {
        router.show(routeType: .signIn)
    }
    
    func showFilterVC() {
        if let router = router as? ProgramListRouter, (self as? ProgramListViewModel) != nil {
            router.show(routeType: .showFilterVC(programListViewModel: self as! ProgramListViewModel))
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
    func responseHandler(_ viewModel: ProgramDetailsFull?, error: Error?, successCompletion: @escaping (_ programsViewModel: ProgramDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
}
