//
//  ProgramDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

struct ProgramDetailViewProperties {
    var isHistoryEnable: Bool = false
    var isInvestEnable: Bool = false
    var isWithdrawEnable: Bool = false
    var hasNewRequests: Bool = false
}

final class ProgramDetailViewModel {
    enum SectionType {
        case details
        case investNow
        case yourInvestment
    }
    enum RowType {
        case manager
        case strategy
        case period
    }

    // MARK: - Variables
    var title: String = "Info".uppercased()
    
    private var router: ProgramDetailRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol?
    
    var chartDurationType: ChartDurationType = .all
    var programId: String!
    private var equityChart: [ChartSimple]?
    public private(set) var programDetailsFull: ProgramDetailsFull? {
        didSet {
            if let availableInvestment = programDetailsFull?.availableInvestment {
                self.availableInvestment = availableInvestment
            }
        }
    }
    
    var viewProperties: ProgramDetailViewProperties?
    var availableInvestment: Double = 0.0
    
    private var sections: [SectionType] = [.details, .investNow, .yourInvestment]
    private var rows: [RowType] = [.manager, .strategy, .period]
    
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailManagerTableViewCellViewModel.self, ProgramStrategyTableViewCellViewModel.self, ProgramPeriodTableViewCellViewModel.self, ProgramInvestNowTableViewCellViewModel.self, ProgramYourInvestmentTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter,
         programId: String? = nil,
         programDetailsFull: ProgramDetailsFull? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil,
         detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol? = nil) {
        self.router = router
        
        if let programId = programId {
            self.programId = programId
        }
        
        if let programDetailsFull = programDetailsFull, let programId = programDetailsFull.id?.uuidString {
            DispatchQueue.main.async {
                self.programDetailsFull = programDetailsFull
            }
            self.programId = programId
        }
        
        self.reloadDataProtocol = reloadDataProtocol
        self.detailChartTableViewCellProtocol = detailChartTableViewCellProtocol
        
        self.updateChart(with: .all) { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 8.0
    }
    
    func numberOfSections() -> Int {
        guard programDetailsFull != nil else {
            return 0
        }
        
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let sectionType = sections[section]
        
        switch sectionType {
        case .details:
            return 3
        default:
            return 1
        }
    }
}

// MARK: - Navigation
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func invest() {
        guard let programId = programId, let currency = programDetailsFull?.currency, let availableToInvest = programDetailsFull?.availableInvestment else { return }
        router.show(routeType: .invest(programId: programId, currency: currency.rawValue, availableToInvest: availableToInvest))
    }
    
    func withdraw() {
        guard let programId = programId, let investedTokens = programDetailsFull?.personalProgramDetails?.value, let currency = programDetailsFull?.currency else { return }
        router.show(routeType: .withdraw(programId: programId, investedTokens: investedTokens, currency: currency.rawValue))
    }
    
    func showFullChart() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.restrictRotation)
        
        guard let programDetailsFull = programDetailsFull else { return }
        router.show(routeType: .fullChart(programDetailsFull: programDetailsFull))
    }
    
    func updateChart(with type: ChartDurationType, completion: @escaping CompletionBlock) {
//        let timeFrame = type.getTimeFrame()
        
//        ProgramDataProvider.getProgramChart(with: timeFrame, programId: programId, completion: { [weak self] (viewModel) in
//            guard viewModel != nil else {
//                return completion(.failure(errorType: .apiError(message: nil)))
//            }
//
//            if let chart = viewModel?.chart {
//                self?.equityChart = chart
//                self?.chartDurationType = type
//            }
//
//            completion(.success)
//        }, errorCompletion: completion)
    }
}

// MARK: - Fetch
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return programDetailsFull?.manager?.username ?? ""
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard programDetailsFull != nil else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .details:
            let rowType = rows[indexPath.row]
            switch rowType {
            case .manager:
                return DetailManagerTableViewCellViewModel()
            case .strategy:
                return ProgramStrategyTableViewCellViewModel()
            case .period:
                return ProgramPeriodTableViewCellViewModel()
            }
        case .investNow:
            return ProgramInvestNowTableViewCellViewModel()
        case .yourInvestment:
            return ProgramYourInvestmentTableViewCellViewModel()
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let currency = ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet(rawValue: getSelectedCurrency()) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        
        ProgramDataProvider.getProgram(programId: self.programId, currencySecondary: currency, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.programDetailsFull = viewModel
            
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func updateDetails(with programDetailsFull: ProgramDetailsFull) {
        self.programDetailsFull = programDetailsFull
        self.didReloadData()
    }
}

extension ProgramDetailViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}
