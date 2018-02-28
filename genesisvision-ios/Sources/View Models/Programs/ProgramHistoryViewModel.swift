//
//  ProgramHistoryViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ProgramHistoryViewModel {
    // MARK: - Variables
    var title: String = "History"
    var investmentProgramId: String?
    
    var router: ProgramHistoryRouter!
    
    var dataType: DataType = .api
    
    var programsCount: String = ""
    var skip = 0
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }

    var viewModels = [ProgramTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ProgramHistoryRouter, investmentProgramId: String) {
        self.router = router
        self.investmentProgramId = investmentProgramId
    }
}

// MARK: - TableView
extension ProgramHistoryViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Fetch
extension ProgramHistoryViewModel {
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
            var allViewModels = self?.viewModels ?? [ProgramTableViewCellViewModel]()
            
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
    func model(for index: Int) -> ProgramTableViewCellViewModel? {
        return viewModels[index]
    }

    // MARK: - Private methods
    private func apiInvestmentPrograms(withFilter filter: InvestmentProgramsFilter, completion: @escaping (_ investmentProgramsViewModel: InvestmentProgramsViewModel?) -> Void) {
        InvestorAPI.apiInvestorInvestmentProgramsPost(filter: filter) { [weak self] (viewModel, error) in
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
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            let filter = InvestmentProgramsFilter(managerId: nil, brokerId: nil, brokerTradeServerId: nil, investMaxAmountFrom: nil, investMaxAmountTo: nil, sorting: nil, skip: skip, take: Constants.Api.take)
            
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
            break
        }
    }
}

