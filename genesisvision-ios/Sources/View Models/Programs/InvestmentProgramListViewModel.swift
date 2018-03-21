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
    
    private var sections: [SectionType] = [.header, .programList]
    
    var router: InvestmentProgramListRouter!
    var state: InvestmentProgramListViewState?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dataType: DataType = .api
    var programsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }

    var filter: InvestmentProgramsFilter?
    
    var searchText = ""
    var investmentProgramViewModels = [ProgramTableViewCellViewModel]()
    
    
    // MARK: - Init
    init(withRouter router: InvestmentProgramListRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
            
        filter = InvestmentProgramsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: nil, investMaxAmountTo: nil, sorting: .byOrdersAsc, name: searchText, levelMin: nil, levelMax: nil, profitAvgMin: nil, profitAvgMax: nil, profitTotalMin: nil, profitTotalMax: nil, profitTotalPercentMin: nil, profitTotalPercentMax: nil, profitAvgPercentMin: nil, profitAvgPercentMax: nil, profitTotalChange: nil, periodMin: nil, periodMax: nil, skip: skip, take: take)
        
        state = isLogin() ? .programList : .programListWithSignIn
    }
    
    // MARK: - Public methods
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    func signInButtonEnable() -> Bool {
        return state == .programListWithSignIn
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
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .programList:
            guard let sort = filter?.sorting else { return "Sort by " }
            
            return "Sort by " + getSortingValue(sortingKey: sort)
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
    
    func showDetail(with investmentProgramId: String) {
        router.show(routeType: .showProgramDetail(investmentProgramId: investmentProgramId))
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: ProgramTableViewCellViewModel = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return }
        
        router.show(routeType: .showProgramDetail(investmentProgramId: investmentProgramId.uuidString))
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
    
    func fetchMore(completion: @escaping CompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += take
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.investmentProgramViewModels ?? [ProgramTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
            }, completionError: completion)
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
    
    func getDetailViewController(with indexPath: IndexPath) -> ProgramDetailViewController? {
        guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
            return nil
        }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return nil}
        
        return router.getDetailViewController(with: investmentProgramId.uuidString)
    }
    
    // MARK: - Private methods
    private func apiInvestmentPrograms(withFilter filter: InvestmentProgramsFilter, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        ProgramDataProvider.getPrograms(with: filter) { (viewModel) in
            completion(viewModel)
        }
    }
    
    private func responseHandler(_ viewModel: InvestmentProgramsViewModel?, error: Error?, successCompletion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    private func fakeViewModels(completion: (_ traderCellModels: [ProgramTableViewCellViewModel]) -> Void) {
        let cellModels = [ProgramTableViewCellViewModel]()
        
//        for _ in 0..<Constants.TemplatesCounts.traders {
//            cellModels.append(InvestmentProgramTableViewCellViewModel(investmentProgram: InvestmentProgram.templateEntity))
//        }
        
        completion(cellModels)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) {
        self.investmentProgramViewModels = viewModels
        self.totalCount = totalCount
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let filter = filter else { return completionError(.failure(reason: nil)) }
            
            apiInvestmentPrograms(withFilter: filter, completion: { (investmentProgramsViewModel) in
                guard let investmentPrograms = investmentProgramsViewModel else { return completionError(.failure(reason: nil)) }
                
                var investmentProgramViewModels = [ProgramTableViewCellViewModel]()
                
                let totalCount = investmentPrograms.total ?? 0
                
                investmentPrograms.investmentPrograms?.forEach({ (investmentProgram) in
                    let traderTableViewCellModel = ProgramTableViewCellViewModel(investmentProgram: investmentProgram)
                    investmentProgramViewModels.append(traderTableViewCellModel)
                })
                
                completionSuccess(totalCount, investmentProgramViewModels)
                completionError(.success)
            })
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
        return "you don’t have \nany programs"
    }
    
    func noDataImageName() -> String {
        let imageName = "img_program_list_logo"
        return imageName
    }
    
    func noDataButtonTitle() -> String {
        let text = "Update"
        return text.uppercased()
    }
}
