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
        case header
        case manager
        case statistics
        case strategy
        case period
    }

    // MARK: - Variables
    var title: String = "Info"
    
    var assetType: AssetType = .program
    
    private var router: ProgramInfoRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var inRequestsDelegateManager = InRequestsDelegateManager()
    
    var chartDurationType: ChartDurationType = .all
    var assetId: String!
    var requestSkip = 0
    var requestTake = ApiKeys.take
    weak var programHeaderProtocol: ProgramHeaderProtocol?
    
    private var equityChart: [SimpleChartPoint]?
    public private(set) var tradingAccounts: ItemsViewModelTradingAccountDetails?
    public private(set) var signalSubscription: SignalSubscription?
    public private(set) var programDetailsFull: ProgramFollowDetailsFull? {
        didSet {
            router.programViewController.viewModel.programDetailsFull = programDetailsFull
        }
    }
    
    var availableInvestment: Double {
        return programDetailsFull?.programDetails?.availableInvestmentBase ?? 0.0
    }
    
    private var sections: [SectionType] = [.details]
    private var rows: [RowType] = [.header, .manager, .statistics, .strategy, .period]
    
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramHeaderTableViewCellViewModel.self,
                DetailManagerTableViewCellViewModel.self,
                DetailStatisticsTableViewCellViewModel.self,
                DefaultTableViewCellViewModel.self,
                ProgramPeriodTableViewCellViewModel.self,
                ProgramInvestNowTableViewCellViewModel.self,
                ProgramYourInvestmentTableViewCellViewModel.self,
                InfoSignalsTableViewCellViewModel.self,
                InfoSubscriptionTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramInfoRouter,
         assetId: String? = nil,
         programDetailsFull: ProgramFollowDetailsFull? = nil,
         reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router

        if let assetId = assetId {
            self.assetId = assetId
        }
        
        if let programDetailsFull = programDetailsFull, let assetId = programDetailsFull.id?.uuidString {
            self.programDetailsFull = programDetailsFull
            self.assetId = assetId
            getSignalSubscription { (result) in
                
            }
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
    
    func showAboutLevels() {
        guard let rawValue = programDetailsFull?.tradingAccountInfo?.currency?.rawValue, let currency = CurrencyType(rawValue: rawValue) else { return }
        
        router.showAboutLevels(currency)
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
    
    func updateSections() {
        sections = [SectionType]()
        guard let programDetailsFull = programDetailsFull else { return }
        sections.append(.details)

        switch assetType {
        case .program:
            sections.append(.investNow)
            
            guard let programDetails = programDetailsFull.programDetails else { return }
            if let isInvested = programDetails.personalDetails?.isInvested, isInvested, let status = programDetails.personalDetails?.status, status != .ended {
                sections.append(.yourInvestment)
            }
        case .follow:
            guard programDetailsFull.followDetails != nil else { return }
            sections.append(.signals)
            
            if signalSubscription != nil {
                sections.append(.subscriptionDetail)
            }
        default:
            break
        }
        
        reloadDataProtocol?.didReloadData()
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
        guard let assetId = assetId, let currency = programDetailsFull?.tradingAccountInfo?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .invest(assetId: assetId, programCurrency: programCurrency))
    }
    
    func withdraw() {
        guard let assetId = assetId, let currency = programDetailsFull?.tradingAccountInfo?.currency, let programCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .withdraw(assetId: assetId, programCurrency: programCurrency))
    }
    
    private func reinvest(_ value: Bool) {
        if value {
            ProgramsDataProvider.reinvestOn(with: self.assetId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        } else {
            ProgramsDataProvider.reinvestOff(with: self.assetId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        }
    }
    
    private func subscribe(_ value: Bool, currency: CurrencyType? = nil, tradingAccountId: UUID? = nil) {
        guard let assetId = assetId else { return }
        
        value
            ? router.show(routeType: .unsubscribe(assetId: assetId))
            : router.show(routeType: .subscribe(assetId: assetId, currency: currency, tradingAccountId: tradingAccountId))
    }
    
    private func editSubscription() {
        guard let signalSubscription = signalSubscription else { return }
        router.show(routeType: .editSubscribe(assetId: assetId, signalSubscription: signalSubscription))
    }

    func createAccount(completion: @escaping CreateAccountCompletionBlock) {
        guard let assetId = assetId, let currency = programDetailsFull?.tradingAccountInfo?.currency, let leverage = programDetailsFull?.tradingAccountInfo?.leverageMax, let programCurrency = CurrencyType(rawValue: currency.rawValue), let brokerId = programDetailsFull?.brokerDetails?.id else { return }
        
        router.show(routeType: .createAccount(assetId: assetId, brokerId: brokerId, leverage: leverage, programCurrency: programCurrency, completion: completion))
    }
}

// MARK: - Fetch
extension ProgramInfoViewModel {
    // MARK: - Public methods
    func getNickname() -> String {
        return programDetailsFull?.owner?.username ?? ""
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard programDetailsFull != nil else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .details:
            let rowType = rows[indexPath.row]
            switch rowType {
            case .header:
                guard let details = programDetailsFull else { return nil }
                return ProgramHeaderTableViewCellViewModel(details: details, delegate: programHeaderProtocol)
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
            return InfoSignalsTableViewCellViewModel(programDetailsFull: programDetailsFull, isFollowed: signalSubscription != nil, infoSignalsProtocol: self)
        case .subscriptionDetail:
            return InfoSubscriptionTableViewCellViewModel(signalSubscription: signalSubscription, infoSignalsProtocol: self)
        }
    }
    
    func fetch(_ completion: @escaping CompletionBlock) {
        switch assetType {
        case .program:
            ProgramsDataProvider.get(self.assetId, completion: { [weak self] (viewModel) in
                guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                self?.programDetailsFull = viewModel
                self?.updateSections()
                self?.getSignalSubscription(completion)
            }, errorCompletion: completion)
        case .follow:
            FollowsDataProvider.get(self.assetId, completion: { [weak self] (viewModel) in
                guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                
                self?.programDetailsFull = viewModel
                self?.updateSections()
                self?.getSignalSubscription(completion)
            }, errorCompletion: completion)
        default:
            break
        }
    }
    
    func getSignalSubscription(_ completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return }
        FollowsDataProvider.getSubscriptions(with: assetId, onlyActive: true, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            if let signalSubscription = viewModel.items?.first {
                self?.signalSubscription = signalSubscription
                self?.updateSections()
            }
            
            self?.getAccounts(completion)
        }, errorCompletion: completion)
    }
    func getAccounts(_ completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return }
        SignalDataProvider.attachAccounts(assetId: assetId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.tradingAccounts = viewModel
            self?.updateSections()
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func updateDetails(with programDetailsFull: ProgramFollowDetailsFull) {
        self.programDetailsFull = programDetailsFull
        self.getSignalSubscription { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
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
        guard let assetId = assetId else { return }
        
        ProgramsDataProvider.getRequests(with: assetId, skip: requestSkip, take: requestTake, completion: { [weak self] (requests) in
            if let items = requests?.items, items.count > 0, let parentRouter = self?.router.parentRouter as? ProgramRouter, let viewController = parentRouter.programInfoViewController {
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
        
        if signalSubscription != nil {
            createAccount { [weak self] (accountId) in
                self?.subscribe(true)
            }
        } else {
            subscribe(false)
        }
    }
    
    func didTapEditButton() {
        editSubscription()
    }
}
