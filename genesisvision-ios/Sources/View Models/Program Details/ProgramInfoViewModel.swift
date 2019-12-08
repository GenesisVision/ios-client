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
    
    private var equityChart: [ChartSimple]?
    public private(set) var programDetailsFull: ProgramDetailsFull? {
        didSet {
            sections = [.details, .investNow]
            
            if let availableInvestment = programDetailsFull?.availableInvestmentBase {
                self.availableInvestment = availableInvestment
            }
            
            if let isInvested = programDetailsFull?.personalProgramDetails?.isInvested, isInvested, let status = programDetailsFull?.personalProgramDetails?.status, status != .ended {
                if !sections.contains(.yourInvestment) {
                    sections.insert(.yourInvestment, at: 1)
                }
            }
            
            if signalEnable, let hasActiveSubscription = programDetailsFull?.personalProgramDetails?.signalSubscription?.hasActiveSubscription, hasActiveSubscription {
                if !sections.contains(.subscriptionDetail) {
                    sections.insert(.subscriptionDetail, at: 1)
                }
            }
            
            if signalEnable, let isSignalProgram = programDetailsFull?.isSignalProgram, isSignalProgram {
                if !sections.contains(.signals) {
                    sections.insert(.signals, at: 1)
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
         programDetailsFull: ProgramDetailsFull? = nil,
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
        guard let managerId = programDetailsFull?.manager?.id?.uuidString else { return }
        router.show(routeType: .manager(managerId: managerId))
    }
    
    func invest() {
        guard let programId = programId, let currency = programDetailsFull?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .invest(programId: programId, programCurrency: programCurrency))
    }
    
    func withdraw() {
        guard let programId = programId, let currency = programDetailsFull?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
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
        guard let signalSubscription = programDetailsFull?.personalProgramDetails?.signalSubscription else { return }
        router.show(routeType: .editSubscribe(programId: programId, signalSubscription: signalSubscription))
    }

    func createAccount(completion: @escaping CreateAccountCompletionBlock) {
        guard let programId = programId, let currency = programDetailsFull?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        
        router.show(routeType: .createAccount(programId: programId, programCurrency: programCurrency, completion: completion))
    }
}

// MARK: - Fetch
extension ProgramInfoViewModel {
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
                guard let manager = programDetailsFull?.manager else { return nil }
                return DetailManagerTableViewCellViewModel(manager: manager)
            case .statistics:
                return DetailStatisticsTableViewCellViewModel(programDetailsFull: programDetailsFull)
            case .strategy:
                return DefaultTableViewCellViewModel(title: "Strategy", subtitle: programDetailsFull?.description)
            case .period:
                return ProgramPeriodTableViewCellViewModel(periodDuration: programDetailsFull?.periodDuration, periodStarts: programDetailsFull?.periodStarts, periodEnds: programDetailsFull?.periodEnds)
            }
        case .yourInvestment:
            return ProgramYourInvestmentTableViewCellViewModel(programDetailsFull: programDetailsFull, yourInvestmentProtocol: self)
        case .investNow:
            return ProgramInvestNowTableViewCellViewModel(programDetailsFull: programDetailsFull, investNowProtocol: self)
        case .signals:
            return InfoSignalsTableViewCellViewModel(programDetailsFull: programDetailsFull, type: .signal, infoSignalsProtocol: self)
        case .subscriptionDetail:
            return InfoSignalsTableViewCellViewModel(programDetailsFull: programDetailsFull, type: .subscription, infoSignalsProtocol: self)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let currency = ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet(rawValue: getSelectedCurrency()) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        
        ProgramsDataProvider.get(programId: self.programId, currencySecondary: currency, completion: { [weak self] (viewModel) in
            guard viewModel != nil else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.programDetailsFull = viewModel
            
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func updateDetails(with programDetailsFull: ProgramDetailsFull) {
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
        
        ProgramsDataProvider.getRequests(with: programId, skip: requestSkip, take: requestTake, completion: { [weak self] (programRequests) in
            if let requests = programRequests?.requests, requests.count > 0, let parentRouter = self?.router.parentRouter as? ProgramTabmanRouter, let viewController = parentRouter.programInfoViewController {
                viewController.showRequests(programRequests)
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
        
        if let hasSignalAccount = programDetailsFull?.personalProgramDetails?.signalSubscription?.hasSignalAccount, !hasSignalAccount {
            createAccount { [weak self] (selectedCurrencyType, depositAmount) in
                self?.subscribe(true, initialDepositCurrency: selectedCurrencyType, initialDepositAmount: depositAmount)
            }
        } else if let isFollowSignals = programDetailsFull?.personalProgramDetails?.signalSubscription?.hasActiveSubscription {
            subscribe(isFollowSignals)
        }
    }
    
    func didTapEditButton() {
        editSubscription()
    }
}
