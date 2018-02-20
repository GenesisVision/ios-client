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
    private var router: ProgramDetailRouter
    private var investmentProgram: InvestmentProgram?
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
    init(withRouter router: ProgramDetailRouter, with investmentProgram: InvestmentProgram, state: ProgramDetailViewState) {
        self.router = router
        self.investmentProgram = investmentProgram
        self.state = state
    }
    
    // MARK: - Public methods
    func getNickname() -> String {
        return investmentProgram?.account?.login ?? ""
    }
    
    func getModel() -> InvestmentProgram? {
        return investmentProgram
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
        guard investmentProgram != nil else {
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
        guard let investment = investmentProgram?.investment else {
            return nil
        }
        
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return ProgramDetailHeaderTableViewCellViewModel(investment: investment)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: [], name: "")
        }
    }
}

// MARK: - Navigation
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func invest() {
        router.show(routeType: .invest)
    }
    
    func withdraw() {
        router.show(routeType: .withdraw)
    }
    
    func showHistory() {
        router.show(routeType: .history)
    }
}
