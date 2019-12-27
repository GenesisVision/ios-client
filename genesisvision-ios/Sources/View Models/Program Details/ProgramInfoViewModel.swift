//
//  ProgramInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class ProgramInfoViewModel {
    enum SectionType {
        case details
        case signals
        case yourInvestment
        case investNow
        case subscriptionDetail
    }
    enum RowType {
        case manager
        case statistics
        case strategy
        case period
    }

    // MARK: - Variables
    var title: String = "Info"
    
    private var router: ProgramInfoRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var inRequestsDelegateManager = InRequestsDelegateManager()
    
    var chartDurationType: ChartDurationType = .all
    var programId: String!
    var requestSkip = 0
    var requestTake = ApiKeys.take
    
    private var equityChart: [SimpleChartPoint]?
    public private(set) var signalSubscription: SignalSubscription?
    public private(set) var programDetailsFull: ProgramFollowDetailsFull? {
        didSet {
            sections = [.details, .investNow]
            
            if let availableInvestment = programDetailsFull?.programDetails?.availableInvestmentBase {
                self.availableInvestment = availableInvestment
            }
            
            if let isInvested = programDetailsFull?.programDetails?.personalDetails?.isInvested, isInvested, let status = programDetailsFull?.programDetails?.personalDetails?.status, status != .ended {
                if !sections.contains(.yourInvestment) {
                    sections.insert(.yourInvestment, at: 1)
                }
            }
        }
    }
    
    var availableInvestment: Double = 0.0
    
    private var sections: [SectionType] = [.details, .investNow]
    private var rows: [RowType] = [.manager, .statistics, .strategy, .period]
    
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailManagerTableViewCellViewModel.self,
                DetailStatisticsTableViewCellViewModel.self,
                DefaultTableViewCellViewModel.self,
                ProgramPeriodTableViewCellViewModel.self,
                ProgramInvestNowTableViewCellViewModel.self,
                ProgramYourInvestmentTableViewCellViewModel.self,
                InfoSignalsTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramInfoRouter,
         programId: String? = nil,
         programDetailsFull: ProgramFollowDetailsFull? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router

        if let programId = programId {
            self.programId = programId
        }
        
        if let programDetailsFull = programDetailsFull, let programId = programDetailsFull.id?.uuidString {
            self.programDetailsFull = programDetailsFull
            self.programId = programId
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
            return 30.0
        }
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
    
    func hideHeader(value: Bool = true) {
        if let detailsRouter = router.parentRouter, let programRouter = detailsRouter.parentRouter as? ProgramRouter {
            programRouter.programViewController.hideHeader(value)
        }
    }
}

// MARK: - Navigation
extension ProgramInfoViewModel {
    // MARK: - Public methods
    func showManagerVC() {
        guard let managerId = programDetailsFull?.owner?.id?.uuidString else { return }
        router.show(routeType: .manager(managerId: managerId))
    }
    
    func invest() {
        guard let programId = programId, let currency = programDetailsFull?.tradingAccountInfo?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .invest(programId: programId, programCurrency: programCurrency))
    }
    
    func withdraw() {
        guard let programId = programId, let currency = programDetailsFull?.tradingAccountInfo?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .withdraw(programId: programId, programCurrency: programCurrency))
    }
    
    private func reinvest(_ value: Bool) {
        if value {
            ProgramsDataProvider.reinvestOn(with: self.programId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        } else {
            ProgramsDataProvider.reinvestOff(with: self.programId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        }
    }
    
    private func subscribe(_ value: Bool, initialDepositCurrency: CurrencyType? = nil, initialDepositAmount: Double? = nil) {
        guard let programId = programId else { return }
        
        value
            ? router.show(routeType: .unsubscribe(programId: programId))
            : router.show(routeType: .subscribe(programId: programId, initialDepositCurrency: initialDepositCurrency, initialDepositAmount: initialDepositAmount))
    }
    
    private func editSubscription() {
        //FIXME:
//        guard let signalSettings = programDetailsFull?.signalSettings else { return }
//        router.show(routeType: .editSubscribe(programId: programId, signalSubscription: signalSubscription))
    }

    //FIXME:
    func createAccount(completion: @escaping CreateAccountCompletionBlock) {
        guard let programId = programId, let currency = programDetailsFull?.tradingAccountInfo?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        
        router.show(routeType: .createAccount(programId: programId, programCurrency: programCurrency, completion: completion))
    }
}

// MARK: - Fetch
extension ProgramInfoViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return programDetailsFull?.owner?.username ?? ""
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
                guard let owner = programDetailsFull?.owner else { return nil }
                return DetailManagerTableViewCellViewModel(profilePublic: owner)
            case .statistics:
                return DetailStatisticsTableViewCellViewModel(programFollowDetailsFull: programDetailsFull)
            case .strategy:
                return DefaultTableViewCellViewModel(title: "Strategy", subtitle: programDetailsFull?.publicInfo?.description)
            case .period:
                return ProgramPeriodTableViewCellViewModel(periodDuration: programDetailsFull?.programDetails?.periodDuration, periodStarts: programDetailsFull?.programDetails?.periodStarts, periodEnds: programDetailsFull?.programDetails?.periodEnds)
            }
        case .yourInvestment:
            return ProgramYourInvestmentTableViewCellViewModel(programDetailsFull: programDetailsFull, yourInvestmentProtocol: self)
        case .investNow:
            return ProgramInvestNowTableViewCellViewModel(programDetailsFull: programDetailsFull, investNowProtocol: self)
        case .signals:
            return InfoSignalsTableViewCellViewModel(programDetailsFull: programDetailsFull, infoSignalsProtocol: self)
        case .subscriptionDetail:
            return InfoSubscriptionTableViewCellViewModel(signalSubscription: signalSubscription, infoSignalsProtocol: self)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        ProgramsDataProvider.get(self.programId, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.programDetailsFull = viewModel
            
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func updateDetails(with programDetailsFull: ProgramFollowDetailsFull) {
        self.programDetailsFull = programDetailsFull
        self.reloadDataProtocol?.didReloadData()
    }
}

extension ProgramInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}

extension ProgramInfoViewModel: YourInvestmentProtocol {
    func didTapWithdrawButton() {
        withdraw()
    }
    
    func didChangeSwitch(value: Bool) {
        reinvest(value)
    }
    
    func didTapStatusButton() {
        guard let programId = programId else { return }
        
        ProgramsDataProvider.getRequests(with: programId, skip: requestSkip, take: requestTake, completion: { [weak self] (requests) in
            if let items = requests?.items, items.count > 0, let parentRouter = self?.router.parentRouter as? ProgramTabmanRouter, let viewController = parentRouter.programInfoViewController {
                viewController.showRequests(requests)
            }
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
}

extension ProgramInfoViewModel: InvestNowProtocol {
    func didTapEntryFeeTooltipButton(_ tooltipText: String) {
        if let viewController = router.topViewController() as? BaseViewController {
            viewController.showBottomSheet(.text, title: tooltipText, initializeHeight: 130, completion: nil)
        }
    }
    
    func didTapInvestButton() {
        guard AuthManager.isLogin() else {
            router.signInAction()
            return
        }
        
        if availableInvestment > 0 {
            invest()
        } else if let topViewController = router.topViewController() {
            topViewController.showAlertWithTitle(title: "", message: String.Alerts.noAvailableTokens, actionTitle: "OK", cancelTitle: nil, handler: nil, cancelHandler: nil)
        }
    }
}

extension ProgramInfoViewModel: InfoSignalsProtocol {
    func didTapFollowButton() {
        guard AuthManager.isLogin() else {
            router.signInAction()
            return
        }
        //FIXME:
        if let isActive = programDetailsFull?.followDetails?.signalSettings?.isActive, !isActive {
            createAccount { [weak self] (selectedCurrencyType, depositAmount) in
                self?.subscribe(true, initialDepositCurrency: selectedCurrencyType, initialDepositAmount: depositAmount)
            }
        } else if let isActive = programDetailsFull?.followDetails?.signalSettings?.isActive {
            subscribe(isActive)
        }
    }
    
    func didTapEditButton() {
        editSubscription()
    }
}
