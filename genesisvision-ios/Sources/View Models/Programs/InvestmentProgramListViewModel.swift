//
//  InvestmentProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ListState {
    case tournament, programList, programListWithSignIn
}

class InvestmentProgramListViewModel {
    
    // MARK: - Init
    init(withRouter router: InvestmentProgramListRouter) {
        self.router = router
        
        state = isLogin() ? .programList : .programListWithSignIn
    }
    
    // MARK: - Variables
    var title: String = "Invest"
    
    var router: InvestmentProgramListRouter!
    
    var dataType: DataType = .api
    var state: ListState?
    
    var skip = 0                            //offset
    var totalCount = 0                      //total count of programs
    
    var sorting: InvestmentsFilter.Sorting = .byOrdersAsc
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    
    var investmentProgramViewModels = [InvestmentProgramTableViewCellViewModel]()
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [InvestmentProgramTableViewCellViewModel.self]
    }
    
    // MARK: - Public methods
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    func signInButtonEnable() -> Bool {
        return state == .programListWithSignIn
    }
    
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
            var allViewModels = self?.investmentProgramViewModels ?? [InvestmentProgramTableViewCellViewModel]()

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
    
    // MARK: - <#Section#>
    func modelsCount() -> Int {
        return investmentProgramViewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> InvestmentProgramTableViewCellViewModel? {
        return investmentProgramViewModels[index]
    }
    
    func getDetailViewController(with index: Int) -> ProgramDetailViewController? {
        guard let model = model(for: index) else {
            return nil
        }
        
        return router.getDetailViewController(withEntity: model.investmentProgramEntity)
    }
    
    // MARK: - Navigation
    func showSignInVC() {
        router.show(routeType: .signIn)
    }
    
    func showFilterVC() {
        router.show(routeType: .showFilterVC(investmentProgramListViewModel: self))
    }
    
    func showDetail(with programEntity: InvestmentProgramEntity) {
        router.show(routeType: .showProgramDetail(programEntity: programEntity))
    }
    
    // MARK: - Private methods
    private func apiInvestmentPrograms(withFilter filter: InvestmentsFilter, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        InvestorAPI.apiInvestorInvestmentsPost(filter: filter) { [weak self] (viewModel, error) in
            self?.responseHandler(viewModel, error: error, successCompletion: { (programs) in
                completion(programs)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private func responseHandler(_ viewModel: InvestmentProgramsViewModel?, error: Error?, successCompletion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    private func fakeViewModels(completion: (_ traderCellModels: [InvestmentProgramTableViewCellViewModel]) -> Void) {
        var cellModels = [InvestmentProgramTableViewCellViewModel]()
        
        for _ in 0..<Constants.TemplatesCounts.traders {
            cellModels.append(InvestmentProgramTableViewCellViewModel(investmentProgramEntity: InvestmentProgramEntity.templateEntity))
        }
        
        completion(cellModels)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [InvestmentProgramTableViewCellViewModel]) {
        self.investmentProgramViewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [InvestmentProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            let filter = InvestmentsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: investMaxAmountFrom, investMaxAmountTo: investMaxAmountTo, sorting: sorting, skip: skip, take: Constants.Api.take)
            
            apiInvestmentPrograms(withFilter: filter, completion: { (investmentProgramsViewModel) in
                guard let investmentPrograms = investmentProgramsViewModel else { return completionError(.failure(reason: nil)) }
                
                var investmentProgramViewModels = [InvestmentProgramTableViewCellViewModel]()
                
                let totalCount = investmentPrograms.total ?? 0
                
                investmentPrograms.investments?.forEach({ (investmentProgram) in
                    let entity = InvestmentProgramEntity()
                    entity.traslation(fromInvestmentProgram: investmentProgram)
                    let traderTableViewCellModel = InvestmentProgramTableViewCellViewModel(investmentProgramEntity: entity)
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
