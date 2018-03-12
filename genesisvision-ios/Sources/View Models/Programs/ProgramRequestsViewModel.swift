//
//  ProgramRequestsViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class ProgramRequestsViewModel {
    // MARK: - Variables
    var title: String = "Requests"
    private var investmentProgramId: String!
    private weak var programDetailProtocol: ProgramDetailProtocol?
    
    var router: ProgramRequestsRouter!
    
    var requestsCount: String = ""
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            requestsCount = "\(totalCount) requests"
        }
    }
    
    var viewModels = [ProgramRequestTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ProgramRequestsRouter, investmentProgramId: String, programDetailProtocol: ProgramDetailProtocol) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.programDetailProtocol = programDetailProtocol
    }
}


// MARK: - TableView
extension ProgramRequestsViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramRequestTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Navigation
extension ProgramRequestsViewModel {
    // MARK: - Public methods
    func cancel(with requestID: String, completion: @escaping CompletionBlock) {
        ProgramRequestDataProvider.cancelRequest(requestId: requestID, completion: completion)
    }
    
    func goToBack() {
        programDetailProtocol?.didRequestCanceled()
        router.goToBack()
    }
}

// MARK: - Fetch
extension ProgramRequestsViewModel {
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
            var allViewModels = self?.viewModels ?? [ProgramRequestTableViewCellViewModel]()
            
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
    func model(for index: Int) -> ProgramRequestTableViewCellViewModel? {
        return viewModels[index]
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [ProgramRequestTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramRequestTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: investmentProgramId) else { return completionError(.failure(reason: nil)) }
        
        let filter = InvestmentProgramRequestsFilter(investmentProgramId: uuid, dateFrom: nil, dateTo: nil, status: .new, type: nil, skip: skip, take: take)
        
        ProgramRequestDataProvider.getRequests(filter: filter) { [weak self] (requests) in
            guard let requests = requests else { return completionError(.failure(reason: nil)) }
            
            var programRequestViewModels = [ProgramRequestTableViewCellViewModel]()
            
            let totalCount = requests.total ?? 0
            
            requests.requests?.forEach({ (programRequest) in
                guard let vc = self?.router.currentController() else { return }
                let programRequestTableViewCellModel = ProgramRequestTableViewCellViewModel(request: programRequest, lastRequest: requests.requests?.count == 1, delegate: vc as? ProgramRequestTableViewCellProtocol)
                programRequestViewModels.append(programRequestTableViewCellModel)
            })
            
            completionSuccess(totalCount, programRequestViewModels)
            completionError(.success)

        }
    }
}
