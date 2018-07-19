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
        case availableToInvest
    }

    // MARK: - Variables
    var title: String = "Details".uppercased()
    
    private var router: ProgramDetailRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol?
    
    var chartDurationType: ChartDurationType = .all
    var investmentProgramId: String!
    private var equityChart: [TradeChart]?
    public private(set) var investmentProgramDetails: InvestmentProgramDetails? {
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
            
            if let availableInvestment = investmentProgramDetails?.availableInvestment {
                self.availableInvestment = availableInvestment
            }
        }
    }
    
    var viewProperties: ProgramDetailViewProperties?
    var availableInvestment: Double = 0.0
    
    private var sections: [SectionType] = [.header,
                                           .chart,
                                           .details,
                                           .moreDetails,
                                           .availableToInvest]
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramDetailsTableViewCellViewModel.self, ProgramDetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self, ProgramMoreDetailsTableViewCellViewModel.self, DetailTextTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter,
         investmentProgramId: String? = nil,
         investmentProgramDetails: InvestmentProgramDetails? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil,
         detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol? = nil) {
        self.router = router
        
        if let investmentProgramId = investmentProgramId {
            self.investmentProgramId = investmentProgramId
        }
        
        if let investmentProgramDetails = investmentProgramDetails, let investmentProgramId = investmentProgramDetails.id?.uuidString {
            DispatchQueue.main.async {
                self.investmentProgramDetails = investmentProgramDetails
            }
            self.investmentProgramId = investmentProgramId
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
        return 0.0
    }
    
    func numberOfSections() -> Int {
        guard investmentProgramDetails != nil else {
            return 0
        }
        
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
}

// MARK: - Navigation
extension ProgramDetailViewModel {
    // MARK: - Public methods
    func invest() {
        guard let investmentProgramId = investmentProgramId, let currency = investmentProgramDetails?.currency, let availableToInvest = investmentProgramDetails?.availableInvestment else { return }
        router.show(routeType: .invest(investmentProgramId: investmentProgramId, currency: currency.rawValue, availableToInvest: availableToInvest))
    }
    
    func withdraw() {
        guard let investmentProgramId = investmentProgramId, let investedTokens = investmentProgramDetails?.investedTokens, let currency = investmentProgramDetails?.currency else { return }
        router.show(routeType: .withdraw(investmentProgramId: investmentProgramId, investedTokens: investedTokens, currency: currency.rawValue))
    }
    
    func showFullChart() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.restrictRotation)
        
        guard let investmentProgramDetails = investmentProgramDetails else { return }
        router.show(routeType: .fullChart(investmentProgramDetails: investmentProgramDetails))
    }
    
    func updateChart(with type: ChartDurationType, completion: @escaping CompletionBlock) {
        let timeFrame = type.getTimeFrame()
        
        ProgramDataProvider.getProgramChart(with: timeFrame, investmentProgramId: investmentProgramId, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            if let chart = viewModel?.chart {
                self?.equityChart = chart
                self?.chartDurationType = type
            }
            
            completion(.success)
        }, errorCompletion: completion)
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
            return ProgramDetailHeaderTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails, delegate: nil)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: equityChart ?? [], name: "", currencyValue: investmentProgramDetails.currency?.rawValue, chartDurationType: self.chartDurationType, detailChartTableViewCellProtocol: detailChartTableViewCellProtocol)
        case .moreDetails:
            return ProgramMoreDetailsTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails, reloadDataProtocol: self)
        case .details:
            return ProgramDetailsTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails)
        case .availableToInvest:
            return DetailTextTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails)
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
    
    func updateDetails(with investmentProgramDetails: InvestmentProgramDetails) {
        self.investmentProgramDetails = investmentProgramDetails
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
