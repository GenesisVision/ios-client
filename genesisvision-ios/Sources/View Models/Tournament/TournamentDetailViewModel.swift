//
//  TournamentDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TournamentDetailViewModel {
    enum SectionType {
        case header
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Tournament Detail"
    
    private var sections: [SectionType] = [.header, .chart]
    
    var router: TournamentDetailRouter!
    
    private var participantID: String!
    private var participantViewModel: ParticipantViewModel? {
        didSet {
            if let name = participantViewModel?.name {
                self.title = name
            }
        }
    }
    
    var dataType: DataType = .api
    
    var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: TournamentDetailRouter, with participantID: String) {
        self.router = router
        self.participantID = participantID
    }
    
    // MARK: - Public methods
    func getNickname() -> String {
        return participantViewModel?.name ?? ""
    }
    
    // MARK: - TableView
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .chart:
            return "Total funds history"
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .chart:
            return 50.0
        case .header:
            return 0.0
        }
    }
    
    func numberOfSections() -> Int {
        guard participantViewModel != nil else {
            return 0
        }
        
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .chart:
            return 1
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard let participantViewModel = participantViewModel else {
            return nil
        }
        
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return DetailHeaderTableViewCellViewModel(participantViewModel: participantViewModel)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: participantViewModel.chart ?? [], name: participantViewModel.name ?? "")
        }
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
