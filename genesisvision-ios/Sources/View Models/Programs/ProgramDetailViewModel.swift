//
//  ProgramDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

enum ProgramDetailViewState {
    case show, invest, full
}

final class ProgramDetailViewModel {
    enum SectionType {
        case header
        case chart
    }

    // MARK: - Variables
    var title: String = "Program Detail"
    private var router: ProgramDetailRouter
    
    private var investmentProgramID: String!
    private var investmentProgramDetails: InvestmentProgramDetails? {
        didSet {
            if let title = investmentProgramDetails?.title {
                self.title = title
            }
        }
    }
    
    var state: ProgramDetailViewState = .show
    private var sections: [SectionType] = [.header, .chart]
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramDetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter, with investmentProgramID: String, state: ProgramDetailViewState) {
        self.router = router
        self.investmentProgramID = investmentProgramID
        self.state = state
    }
    
    // MARK: - Public methods
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
        guard investmentProgramDetails != nil else {
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

// MARK: - Navigation
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func invest() {
        guard let investmentProgramID = investmentProgramID else { return }
        router.show(routeType: .invest(investmentProgramId: investmentProgramID))
    }
    
    func withdraw() {
        guard let investmentProgramID = investmentProgramID else { return }
        router.show(routeType: .withdraw(investmentProgramId: investmentProgramID))
    }
    
    func showHistory() {
        guard let investmentProgramID = investmentProgramID else { return }
        router.show(routeType: .history(investmentProgramId: investmentProgramID))
    }
}

// MARK: - Fetch
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return investmentProgramDetails?.manager?.username ?? ""
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard let investmentProgramDetails = investmentProgramDetails else {
            return nil
        }
        
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return ProgramDetailHeaderTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: [], name: "")
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        ProgramDataProvider.getProgram(investmentProgramID: self.investmentProgramID) { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(reason: nil))
            }
            
            self?.investmentProgramDetails = viewModel
            
            completion(.success)
        }
    }
}
