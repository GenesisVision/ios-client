//
//  InvestmentProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum InvestmentProgramListViewState {
    case programList, programListWithSignIn
}

final class InvestmentProgramListViewModel {
    // MARK: - Variables
    var title: String = "Invest"
    var router: InvestmentProgramListRouter!
    var state: InvestmentProgramListViewState?
   
    var dataType: DataType = .api
    var programsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }
    var sorting: InvestmentProgramsFilter.Sorting = .byOrdersAsc
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    var searchText = ""
    var investmentProgramViewModels = [ProgramTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: InvestmentProgramListRouter) {
        self.router = router
        
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
        return [ProgramTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return investmentProgramViewModels.count
    }

    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
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
        
        skip += Constants.Api.take
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
    func model(at index: Int) -> ProgramTableViewCellViewModel? {
        return investmentProgramViewModels[index]
    }
    
    func getDetailViewController(with index: Int) -> ProgramDetailViewController? {
        guard let model = model(at: index),
            let investmentProgramId = model.investmentProgram.id
            else { return nil }
        
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
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            let filter = InvestmentProgramsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: investMaxAmountFrom, investMaxAmountTo: investMaxAmountTo, sorting: sorting, skip: skip, take: take)
            
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
