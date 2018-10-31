//
//  FundInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class FundInfoViewModel {
    enum SectionType {
        case details
        case yourInvestment
        case investNow
    }
    enum RowType {
        case manager
        case strategy
    }

    // MARK: - Variables
    var title: String = "Info"
    
    private var router: FundInfoRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var inRequestsDelegateManager = InRequestsDelegateManager()
    
    var chartDurationType: ChartDurationType = .all
    var fundId: String!
    var requestSkip = 0
    var requestTake = Constants.Api.take
    
    private var equityChart: [ChartSimple]?
    public private(set) var fundDetailsFull: FundDetailsFull? {
        didSet {
            if let isInvested = fundDetailsFull?.personalFundDetails?.isInvested, isInvested, let status = fundDetailsFull?.personalFundDetails?.status, status != .ended {
                if !sections.contains(.yourInvestment) {
                    sections.insert(.yourInvestment, at: 1)
                }
            }
        }
    }
    
    var availableInvestment: Double = 0.0
    
    private var sections: [SectionType] = [.details, .investNow]
    private var rows: [RowType] = [.manager, .strategy]
    
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailManagerTableViewCellViewModel.self, DefaultTableViewCellViewModel.self, FundInvestNowTableViewCellViewModel.self, FundYourInvestmentTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: FundInfoRouter,
         fundId: String? = nil,
         fundDetailsFull: FundDetailsFull? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router

        if let fundId = fundId {
            self.fundId = fundId
        }
        
        if let fundDetailsFull = fundDetailsFull, let fundId = fundDetailsFull.id?.uuidString {
            self.fundDetailsFull = fundDetailsFull
            self.fundId = fundId
        }
        
        self.reloadDataProtocol = reloadDataProtocol
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return 20.0
        }
    }
    
    func numberOfSections() -> Int {
        guard fundDetailsFull != nil else {
            return 0
        }
        
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let sectionType = sections[section]
        
        switch sectionType {
        case .details:
            return rows.count
        default:
            return 1
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .details:
            switch rows[indexPath.row] {
            case .manager:
                showManagerVC()
            default:
                break
            }
        default:
            break
        }
    }
}

// MARK: - Navigation
extension FundInfoViewModel {
    // MARK: - Public methods
    func showManagerVC() {
        guard let managerId = fundDetailsFull?.manager?.id?.uuidString else { return }
        router.show(routeType: .manager(managerId: managerId))
    }
    
    func invest() {
        guard let fundId = fundId else { return }
        router.show(routeType: .invest(fundId: fundId))
    }
    
    func withdraw() {
        guard let fundId = fundId else { return }
        router.show(routeType: .withdraw(fundId: fundId))
    }
}

// MARK: - Fetch
extension FundInfoViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return fundDetailsFull?.manager?.username ?? ""
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard fundDetailsFull != nil else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .details:
            let rowType = rows[indexPath.row]
            switch rowType {
            case .manager:
                guard let manager = fundDetailsFull?.manager else { return nil }
                return DetailManagerTableViewCellViewModel(manager: manager)
            case .strategy:
                return DefaultTableViewCellViewModel(title: "Strategy", subtitle: fundDetailsFull?.description)
            }
        case .yourInvestment:
            return FundYourInvestmentTableViewCellViewModel(fundDetailsFull: fundDetailsFull, yourInvestmentProtocol: self)
        case .investNow:
            return FundInvestNowTableViewCellViewModel(fundDetailsFull: fundDetailsFull, investNowProtocol: self)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let currency = FundsAPI.CurrencySecondary_v10FundsByIdGet(rawValue: getSelectedCurrency()) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        
        FundsDataProvider.get(fundId: self.fundId, currencySecondary: currency, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.fundDetailsFull = viewModel
            
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func updateDetails(with fundDetailsFull: FundDetailsFull) {
        self.fundDetailsFull = fundDetailsFull
        self.didReloadData()
    }
}

extension FundInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}

extension FundInfoViewModel: YourInvestmentProtocol {
    func didTapWithdrawButton() {
        withdraw()
    }
}

extension FundInfoViewModel: InvestNowProtocol {
    func didTapInvestButton() {
        invest()
    }
}
