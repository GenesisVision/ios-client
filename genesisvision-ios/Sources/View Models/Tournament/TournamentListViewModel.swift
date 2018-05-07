//
//  TraderListViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class TournamentListViewModel {
    // MARK: - Variables
    var title: String = "Tournament"
    var router: TournamentRouter!
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var programsCount: String = ""
    var equityChartLength = Constants.Api.equityChartLength
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            programsCount = "\(totalCount) programs"
        }
    }
    private var sorting: InvestmentProgramsFilter.Sorting = Constants.Sorting.programListDefault
    var searchText = "" {
        didSet {
            filter?.name = searchText
        }
    }
    var traderTableViewCellViewModels = [TraderTableViewCellViewModel]()
    var filter: InvestmentProgramsFilter?
    
    // MARK: - Init
    init(withRouter router: TournamentRouter, roundNumber: Int?) {
        self.router = router
        filter = InvestmentProgramsFilter(managerId: nil,
                                          brokerId: nil,
                                          brokerTradeServerId: nil,
                                          investMaxAmountFrom: nil,
                                          investMaxAmountTo: nil,
                                          sorting: sorting,
                                          name: searchText,
                                          levelMin: nil,
                                          levelMax: nil,
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
                                          roundNumber: roundNumber,
                                          skip: skip,
                                          take: take)
    }
    
    // MARK: - Public methods
    func noDataText() -> String {
        return "No result.\n\nPlease try again later."
    }
    
    func getDetailViewController(with index: Int) -> ProgramDetailViewController? {
        guard let model = model(for: index) else {
            return nil
        }
        
        let investmentProgram = model.investmentProgram
        guard let investmentProgramId = investmentProgram.id else { return nil}
        
        return router.getDetailViewController(with: investmentProgramId.uuidString)
    }
    
}

// MARK: - TableView
extension TournamentListViewModel {
    // MARK: - Variables
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TraderTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        switch section {
        default:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        default:
            return 0.0
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Navigation
extension TournamentListViewModel {
    // MARK: - Public methods
    func showDetail(with model: InvestmentProgram) {
        router.show(routeType: .showDetail(investmentProgramId: model.id?.uuidString ?? ""))
    }
}

// MARK: - Fetch
extension TournamentListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch(withSearchText: searchText, { [weak self] (totalCount, viewModels) in
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
        fetch(withSearchText: searchText, { [weak self] (totalCount, viewModels) in
            var allViewModels = self?.traderTableViewCellViewModels ?? [TraderTableViewCellViewModel]()
            
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
        
        fetch(withSearchText: searchText, { [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    func modelsCount() -> Int {
        return traderTableViewCellViewModels.count
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> TraderTableViewCellViewModel? {
        return traderTableViewCellViewModels[index]
    }
    
    // MARK: - Private methods
    private func fakeViewModels(completion: (_ traderCellModels: [TraderTableViewCellViewModel]) -> Void) {
        let cellModels = [TraderTableViewCellViewModel]()
        
        completion(cellModels)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [TraderTableViewCellViewModel]) {
        self.traderTableViewCellViewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
    }
    
    private func fetch(withSearchText name: String?, _ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [TraderTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            guard let filter = filter else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            ProgramDataProvider.getPrograms(with: filter, completion: { [weak self] (investmentProgramsViewModel) in
                guard let investmentPrograms = investmentProgramsViewModel else { return completionError(.failure(errorType: .apiError(message: nil))) }
                
                var investmentProgramViewModels = [TraderTableViewCellViewModel]()
                
                let totalCount = investmentPrograms.total ?? 0
                
                investmentPrograms.investmentPrograms?.forEach({ (investmentProgram) in
                    let traderTableViewCellModel = TraderTableViewCellViewModel(investmentProgram: investmentProgram, delegate: self?.router.programsViewController)
                    investmentProgramViewModels.append(traderTableViewCellModel)
                })
                
                completionSuccess(totalCount, investmentProgramViewModels)
                completionError(.success)
                }, errorCompletion: completionError)
        case .fake:
            fakeViewModels { (participantViewModels) in
                completionSuccess(participantViewModels.count, participantViewModels)
                completionError(.success)
            }
        }
    }
    
    private func tournamentParticipantsSummary(completion: @escaping (_ participantsViewModel: ParticipantsSummaryViewModel?) -> Void) {
        TournamentAPI.apiTournamentParticipantsCountGet(completion: { (viewModel, error) in
            guard viewModel != nil else {
                return ErrorHandler.handleApiError(error: error, completion: { (result) in
                    completion(nil)
                })
            }
            
            completion(viewModel)
        })
    }
}
