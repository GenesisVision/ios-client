//
//  TournamentDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class TournamentDetailViewModel {
    // MARK: - Variables
    var router: TournamentDetailRouter!
    
    private var participantID: String!
    private var participantViewModel: ParticipantViewModel? {
        didSet {
            let detailHeaderTableViewCellViewModel = DetailHeaderTableViewCellViewModel(participantViewModel: participantViewModel!)
            
            let detailChartTableViewCellViewModel = DetailChartTableViewCellViewModel(chart: participantViewModel?.chart ?? [])
            
            models = [detailHeaderTableViewCellViewModel, detailChartTableViewCellViewModel]
            
            if let name = participantViewModel?.name {
                self.title = name
            }
        }
    }
    
    var title: String = "Tournament Detail"
    
    var dataType: DataType = .api

//    var detailHeaderTableViewCellViewModel: DetailHeaderTableViewCellViewModel?
//    var detailChartTableViewCellViewModel: DetailChartTableViewCellViewModel?
    var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: TournamentDetailRouter, with participantID: String) {
        self.router = router
        self.participantID = participantID
        
//        setup()
    }
    
    // MARK: - Public methods
    func getNickname() -> String {
        return participantViewModel?.name ?? ""
    }
    
    func modelsCount() -> Int {
        return models?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> CellViewAnyModel? {
        return models?[index]
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        fetch(participantID: self.participantID) { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(reason: nil))
            }
            
            self?.participantViewModel = viewModel
            
            completion(.success)
        }
    }
    
    // MARK: - Private methods
    
    private func fetch(participantID: String, completion: @escaping (_ participantViewModel: ParticipantViewModel?) -> Void) {
        guard let uuid = UUID(uuidString: participantID) else { return completion(nil) }
        
        TournamentAPI.apiTournamentParticipantGet(participantId: uuid) { [weak self] (viewModel, error) in
            self?.responseHandler(viewModel, error: error, successCompletion: { (participant) in
                completion(participant)
            }, errorCompletion: { (error) in
                completion(nil)
            })
        }
    }
    
    private func responseHandler(_ participantViewModel: ParticipantViewModel?, error: Error?, successCompletion: @escaping (_ participant: ParticipantViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard participantViewModel != nil else {
            return ErrorHandler.handleApiError(error: error, completion: errorCompletion)
        }
        
        successCompletion(participantViewModel)
    }
    
}
