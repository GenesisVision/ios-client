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
        case header
        case chart
        case details
        case moreDetails
    }

    // MARK: - Variables
    var title: String = "Program Detail"
    private var router: ProgramDetailRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var programPropertiesForTableViewCellViewProtocol: ProgramPropertiesForTableViewCellViewProtocol?
    private weak var detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol?
    
    private var investmentProgramId: String!
    private var investmentProgramDetails: InvestmentProgramDetails? {
        didSet {
            if let isHistoryEnable = investmentProgramDetails?.isHistoryEnable,
                let isInvestEnable = investmentProgramDetails?.isInvestEnable,
                let isWithdrawEnable = investmentProgramDetails?.isWithdrawEnable,
                let hasNewRequests = investmentProgramDetails?.hasNewRequests {
                self.viewProperties = ProgramDetailViewProperties(isHistoryEnable: isHistoryEnable,
                                                             isInvestEnable: isInvestEnable,
                                                             isWithdrawEnable: isWithdrawEnable,
                                                             hasNewRequests: hasNewRequests)
            }
        }
    }
    
    var viewProperties: ProgramDetailViewProperties?
    
    private var sections: [SectionType] = [.header,
                                           .chart,
                                           .details,
                                           .moreDetails]
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramDetailsTableViewCellViewModel.self, ProgramDetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self, ProgramMoreDetailsTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter,
         investmentProgramId: String,
         reloadDataProtocol: ReloadDataProtocol?,
         programPropertiesForTableViewCellViewProtocol: ProgramPropertiesForTableViewCellViewProtocol?,
         detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.reloadDataProtocol = reloadDataProtocol
        self.programPropertiesForTableViewCellViewProtocol = programPropertiesForTableViewCellViewProtocol
        self.detailChartTableViewCellProtocol = detailChartTableViewCellProtocol
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .chart:
            return nil
        case .header, .details, .moreDetails:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .chart:
            return 0.0
        case .header:
            return 0.0
        case .details:
            return 0.0
        case .moreDetails:
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
        case .details:
            return 1
        case .moreDetails:
            return 1
        }
    }
}

// MARK: - Navigation
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func invest() {
        guard let investmentProgramId = investmentProgramId, let currency = investmentProgramDetails?.currency else { return }
        router.show(routeType: .invest(investmentProgramId: investmentProgramId, currency: currency.rawValue))
    }
    
    func withdraw() {
        guard let investmentProgramId = investmentProgramId, let investedTokens = investmentProgramDetails?.investedTokens, let currency = investmentProgramDetails?.currency else { return }
        router.show(routeType: .withdraw(investmentProgramId: investmentProgramId, investedTokens: investedTokens, currency: currency.rawValue))
    }
    
    func showHistory() {
        guard let investmentProgramId = investmentProgramId else { return }
        router.show(routeType: .history(investmentProgramId: investmentProgramId))
    }
    
    func showTrades() {
        guard let tradesCount = investmentProgramDetails?.tradesCount, tradesCount > 0, let investmentProgramId = investmentProgramId else { return }
        router.show(routeType: .trades(investmentProgramId: investmentProgramId))
    }
    
    func showRequests() {
        guard let investmentProgramId = investmentProgramId else { return }
        router.show(routeType: .requests(investmentProgramId: investmentProgramId))
    }
    
    func showFullChart() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.restrictRotation)
        
        guard let investmentProgramDetails = investmentProgramDetails else { return }
        router.show(routeType: .fullChart(investmentProgramDetails: investmentProgramDetails))
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
            return ProgramDetailHeaderTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails, delegate: self)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: investmentProgramDetails.chart ?? [], name: "", currencyValue: investmentProgramDetails.currency?.rawValue, detailChartTableViewCellProtocol: detailChartTableViewCellProtocol)
        case .moreDetails:
            return ProgramMoreDetailsTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails, reloadDataProtocol: self, programPropertiesForTableViewCellViewProtocol: programPropertiesForTableViewCellViewProtocol)
        case .details:
            return ProgramDetailsTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        ProgramDataProvider.getProgram(investmentProgramId: self.investmentProgramId, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.investmentProgramDetails = viewModel
            
            completion(.success)
        }, errorCompletion: completion)
    }
}


extension ProgramDetailViewModel: DetailHeaderTableViewCellProtocol {
    func showDescriptionDidPress() {
        guard let investmentProgramDetails = investmentProgramDetails else { return }
        router.show(routeType: .description(investmentProgramDetails: investmentProgramDetails))
    }
}

extension ProgramDetailViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}
