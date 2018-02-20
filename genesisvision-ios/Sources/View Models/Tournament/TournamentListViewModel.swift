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
    
    var dataType: DataType = .api
    var participantsCount: String = ""
    var skip = 0
    var totalCount = 0 {
        didSet {
            participantsCount = "\(totalCount) participants"
        }
    }
    var searchText = ""
    var traderTableViewCellViewModels = [TraderTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: TournamentRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    func noDataText() -> String {
        return "No result.\n\nPlease try again later."
    }
    
    func getDetailViewController(with index: Int) -> TournamentDetailViewController? {
        guard let model = model(for: index) else {
            return nil
        }
        
        return router.getDetail(with: model.participantViewModel.id?.uuidString ?? "")
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
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        switch section {
        default:
            return participantsCount
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        default:
            return 26.0
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
}

// MARK: - Navigation
extension TournamentListViewModel {
    // MARK: - Public methods
    func showDetail(with model: ParticipantViewModel) {
        router.show(routeType: .showDetail(participantID: model.id?.uuidString ?? ""))
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
    
    func fetchMore(completion: @escaping CompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += Constants.Api.take
        fetch(withSearchText: searchText, { [weak self] (totalCount, viewModels) in
            var allViewModels = self?.traderTableViewCellViewModels ?? [TraderTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
            }, completionError: completion)
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
    private func tournamentParticipants(withFilter filter: ParticipantsFilter, completion: @escaping (_ participantsViewModel: ParticipantsViewModel?) -> Void) {
        TournamentAPI.apiTournamentParticipantsPost(filter: filter) { [weak self] (participantsViewModel, error) in
            self?.responseHandler(participantsViewModel, error: error, successCompletion: { (participants) in
                completion(participants)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private func responseHandler(_ participantsViewModel: ParticipantsViewModel?, error: Error?, successCompletion: @escaping (_ participants: ParticipantsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard participantsViewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(participantsViewModel)
    }
    
    private func fakeViewModels(completion: (_ traderCellModels: [TraderTableViewCellViewModel]) -> Void) {
        let cellModels = [TraderTableViewCellViewModel]()
        
        completion(cellModels)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [TraderTableViewCellViewModel]) {
        self.traderTableViewCellViewModels = viewModels
        self.totalCount = totalCount
    }
    
    private func fetch(withSearchText name: String?, _ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [TraderTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            let filter = ParticipantsFilter(skip: skip, take: Constants.Api.take, name: name)
            
            tournamentParticipants(withFilter: filter, completion: { (participantViewModels) in
                guard let participantViewModels = participantViewModels else { return completionError(.failure(reason: nil)) }
                
                var viewModels = [TraderTableViewCellViewModel]()
                
                let totalCount = participantViewModels.total ?? 0
                
                participantViewModels.participants?.forEach({ (participantViewModel) in
                    let traderTableViewCellModel = TraderTableViewCellViewModel(participantViewModel: participantViewModel)
                    viewModels.append(traderTableViewCellModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            })
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
