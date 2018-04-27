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
    var title: String = "Program Detail"
    private var router: ProgramDetailRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    private weak var programPropertiesForTableViewCellViewProtocol: ProgramPropertiesForTableViewCellViewProtocol?
    private weak var detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol?
    
    var investmentProgramId: String!
    private var equityChart: [TradeChart]?
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
    
    var isFavorite: Bool {
        return investmentProgramDetails?.isFavorite ?? false
    }
    
    private var sections: [SectionType] = [.header,
                                           .chart,
                                           .details,
                                           .moreDetails,
                                           .availableToInvest]
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramDetailsTableViewCellViewModel.self, ProgramDetailHeaderTableViewCellViewModel.self, DetailChartTableViewCellViewModel.self, ProgramMoreDetailsTableViewCellViewModel.self, DetailTextTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter,
         investmentProgramId: String,
         reloadDataProtocol: ReloadDataProtocol? = nil,
         programPropertiesForTableViewCellViewProtocol: ProgramPropertiesForTableViewCellViewProtocol? = nil,
         detailChartTableViewCellProtocol: DetailChartTableViewCellProtocol? = nil) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.reloadDataProtocol = reloadDataProtocol
        self.programPropertiesForTableViewCellViewProtocol = programPropertiesForTableViewCellViewProtocol
        self.detailChartTableViewCellProtocol = detailChartTableViewCellProtocol
        
        updateChart(with: .all) { [weak self] (result) in
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
        guard let investmentProgramId = investmentProgramId, let currency = investmentProgramDetails?.currency else { return }
        router.show(routeType: .invest(investmentProgramId: investmentProgramId, currency: currency.rawValue))
    }
    
    func withdraw() {
        guard let investmentProgramId = investmentProgramId, let investedTokens = investmentProgramDetails?.investedTokens, let currency = investmentProgramDetails?.currency else { return }
        router.show(routeType: .withdraw(investmentProgramId: investmentProgramId, investedTokens: investedTokens, currency: currency.rawValue))
    }
    
    
    func changeFavorite(completion: @escaping CompletionBlock) {
        guard let investmentProgramId = investmentProgramId,
            let isFavorite = investmentProgramDetails?.isFavorite else { return }
        
        investmentProgramDetails?.isFavorite = !isFavorite
        ProgramDataProvider.programFavorites(isFavorite: isFavorite, investmentProgramId: investmentProgramId) { [weak self] (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                self?.investmentProgramDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
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
    
    func updateChart(with type: ChartDurationType, completion: @escaping CompletionBlock) {
        let timeFrame = type.getTimeFrame()
        
        ProgramDataProvider.getProgramChart(with: timeFrame, investmentProgramId: investmentProgramId, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            if let chart = viewModel?.chart {
                self?.equityChart = chart
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
            return ProgramDetailHeaderTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails, delegate: self)
        case .chart:
            return DetailChartTableViewCellViewModel(chart: equityChart ?? [], name: "", currencyValue: investmentProgramDetails.currency?.rawValue, detailChartTableViewCellProtocol: detailChartTableViewCellProtocol)
        case .moreDetails:
            return ProgramMoreDetailsTableViewCellViewModel(investmentProgramDetails: investmentProgramDetails, reloadDataProtocol: self, programPropertiesForTableViewCellViewProtocol: programPropertiesForTableViewCellViewProtocol)
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
