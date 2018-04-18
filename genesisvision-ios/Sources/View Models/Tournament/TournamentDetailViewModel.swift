//
//  TournamentDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

protocol ViewModelWithTableView {
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

final class TournamentDetailViewModel {
    enum SectionType {
        case header
        case chart
    }
    
    // MARK: - Variables
    var title: String = "Tournament Detail"
    var router: TournamentDetailRouter!

    private var participantId: String!
    private var participantViewModel: ParticipantViewModel? {
        didSet {
            if let name = participantViewModel?.name {
                self.title = name
            }
        }
    }
    private var sections: [SectionType] = [.header, .chart]
    var models: [CellViewAnyModel]?
    var dataType: DataType = .api
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TraderDetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: TournamentDetailRouter, with participantId: String) {
        self.router = router
        self.participantId = participantId
    }
    
    // MARK: - Public methods
    func ipfsHash() -> URL? {
        guard let ipfsHash = participantViewModel?.ipfsHash else {
            print("ipfsHash is not enable")
            return nil
        }
        
        return URL(string: Constants.Api.ipfsPath + ipfsHash)
    }
    
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
}

// MARK: - Fetch
extension TournamentDetailViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return participantViewModel?.name ?? ""
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard let participantViewModel = participantViewModel else {
            return nil
        }
        
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return TraderDetailHeaderTableViewCellViewModel(participantViewModel: participantViewModel)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: [], name: participantViewModel.name ?? "", currencyValue: "", detailChartTableViewCellProtocol: nil)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        TournamentDataProvider.getTournamentParticipant(with: self.participantId) { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.participantViewModel = viewModel
            
            completion(.success)
        }
    }
}
