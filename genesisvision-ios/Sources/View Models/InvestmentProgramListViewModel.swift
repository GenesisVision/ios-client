//
//  InvestmentProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum DataType {
    case api
    case fake
}

class InvestmentProgramListViewModel {
    
    // MARK: - Init
    init(withRouter router: InvestmentProgramListRouter) {
        self.router = router
    }
    
    // MARK: - Variables
    var title: String = "Invest"
    
    var router: InvestmentProgramListRouter!
    
    var dataType: DataType = .api
    var skip = 0            //offset
    var totalCount = 0      //total count of programs
    
    var investmentProgramViewModels = [TraderTableViewCellViewModel]()
    
    // MARK: - Public methods
    
    func isLogin() -> Bool {
        return AuthManager.isLogin()
    }
    
    func fetch(completion: @escaping ApiCompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func fetchMore(completion: @escaping ApiCompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += Constants.Api.take
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.investmentProgramViewModels ?? [TraderTableViewCellViewModel]()

            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
            }, completionError: completion)
    }
    
    func refresh(completion: @escaping ApiCompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
        }, completionError: completion)
    }
    
    func programsCount() -> Int {
        return investmentProgramViewModels.count
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        return programsCount()
    }
    
    func getProgram(atIndex index: Int) -> TraderTableViewCellViewModel? {
        return investmentProgramViewModels[index]
    }
    
    func getProgramDetailViewController(withIndex index: Int) -> TraderViewController? {
        guard let program = getProgram(atIndex: index) else {
            return nil
        }
        
        let entity = program.investmentProgramEntity
        return router.getProgramDetailViewController(withEntity: entity)
    }
    
    func registerNibs() -> [CellViewAnyModel.Type] {
        return [TraderTableViewCellViewModel.self]
    }
    
    // MARK: - Navigation
    func showSignInVC() {
        router.show(routeType: .signIn)
    }
    
    func showFilterVC() {
        router.show(routeType: .showFilterVC)
    }
    
    func showProgramDetail(with programEntity: InvestmentProgramEntity) {
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
    
    private func responseHandler(_ viewModel: InvestmentProgramsViewModel?, error: Error?, successCompletion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void, errorCompletion: @escaping ApiCompletionBlock) {
        
        guard viewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(viewModel)
    }
    
    private func fakeInvestmentPrograms(completion: (_ traderCellModels: [TraderTableViewCellViewModel]) -> Void) {
        var cellModels = [TraderTableViewCellViewModel]()
        
        for _ in 0..<Constants.TemplatesCounts.traders {
            cellModels.append(TraderTableViewCellViewModel(investmentProgramEntity: InvestmentProgramEntity.templateEntity))
        }
        
        completion(cellModels)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [TraderTableViewCellViewModel]) {
        self.investmentProgramViewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [TraderTableViewCellViewModel]) -> Void, completionError: @escaping ApiCompletionBlock) {
        switch dataType {
        case .api:
            let filter = InvestmentsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: nil, investMaxAmountTo: nil, sorting: .byRatingAsc, skip: skip, take: Constants.Api.take)
            apiInvestmentPrograms(withFilter: filter, completion: { (investmentProgramsViewModel) in
                guard let investmentPrograms = investmentProgramsViewModel else { return completionError(.failure(reason: nil)) }
                
                var investmentProgramViewModels = [TraderTableViewCellViewModel]()
                
                let totalCount = investmentPrograms.total ?? 0
                
                investmentPrograms.investments?.forEach({ (investmentProgram) in
                    let entity = InvestmentProgramEntity()
                    entity.traslation(fromInvestmentProgram: investmentProgram)
                    let traderTableViewCellModel = TraderTableViewCellViewModel(investmentProgramEntity: entity)
                    investmentProgramViewModels.append(traderTableViewCellModel)
                })
                
                completionSuccess(totalCount, investmentProgramViewModels)
                completionError(.success)
            })
        case .fake:
            fakeInvestmentPrograms { (investmentProgramViewModels) in
                completionSuccess(investmentProgramViewModels.count, investmentProgramViewModels)
                completionError(.success)
            }
        }
    }
}
