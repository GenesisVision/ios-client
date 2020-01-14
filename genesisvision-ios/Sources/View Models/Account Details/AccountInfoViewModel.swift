//
//  AccountInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.20.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class AccountInfoViewModel {
    enum SectionType {
        case account
        case yourDeposit
        case makeProgram
        case makeFollow
        case subscriptionDetail
    }
    enum RowType {
        case statistics
    }

    // MARK: - Variables
    var title: String = "Info"
    
    private var router: AccountInfoRouter
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var chartDurationType: ChartDurationType = .all
    var assetId: String!
    
    private var equityChart: [SimpleChartPoint]?
    public private(set) var tradingAccounts: ItemsViewModelTradingAccountDetails?
    public private(set) var signalSubscription: SignalSubscription?
    public private(set) var accountDetailsFull: PrivateTradingAccountFull? {
        didSet {
            router.accountViewController.viewModel.accountDetailsFull = accountDetailsFull
            updateSections()
        }
    }
    
    private var sections: [SectionType] = []
    
    private var models: [CellViewAnyModel]?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailStatisticsTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: AccountInfoRouter, assetId: String? = nil, reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router

        if let assetId = assetId {
            self.assetId = assetId
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
        return 1
    }
    
    func showAboutLevels() {
        guard let rawValue = accountDetailsFull?.tradingAccountInfo?.currency?.rawValue, let currency = CurrencyType(rawValue: rawValue) else { return }
        
        router.showAboutLevels(currency)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    func updateSections() {
        sections = [SectionType]()
        guard let accountDetailsFull = accountDetailsFull else { return }
        sections.append(.account)

        reloadDataProtocol?.didReloadData()
    }
}

// MARK: - Navigation
extension AccountInfoViewModel {
    // MARK: - Public methods
    func withdraw() {
        guard let assetId = assetId, let currency = accountDetailsFull?.tradingAccountInfo?.currency, let accountCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .withdraw(assetId: assetId, accountCurrency: accountCurrency))
    }
    
    func deposit() {
        guard let assetId = assetId, let currency = accountDetailsFull?.tradingAccountInfo?.currency, let accountCurrency = CurrencyType(rawValue: currency.rawValue) else { return }
        router.show(routeType: .invest(assetId: assetId, accountCurrency: accountCurrency))
    }
    
    func makeFollow(completion: @escaping CreateAccountCompletionBlock) {
        //FIXIT:
        guard let assetId = assetId else { return }
        router.show(routeType: .createFollow(assetId: assetId, completion: completion))
    }
    
    func makeProgram(completion: @escaping CreateAccountCompletionBlock) {
        //FIXIT:
        guard let assetId = assetId else { return }
        router.show(routeType: .createProgram(assetId: assetId, completion: completion))
    }
    
    func showSubscriptionDetails() {
        //FIXIT:
    }
}

// MARK: - Fetch
extension AccountInfoViewModel {
    // MARK: - Public methods
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        guard accountDetailsFull != nil else {
            return nil
        }
        
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .account:
            break
        case .yourDeposit:
            break
        case .makeProgram:
            break
        case .makeFollow:
            break
        case .subscriptionDetail:
            break
        }
        
        return nil
    }
    
    func fetch(_ completion: @escaping CompletionBlock) {
        AccountsDataProvider.get(self.assetId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.accountDetailsFull = viewModel
            self?.updateSections()
            self?.getSignalSubscription(completion)
        }, errorCompletion: completion)
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
}

extension AccountInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.reloadDataProtocol?.didReloadData()
        }
    }
}

extension AccountInfoViewModel: YourDepositProtocol {
    func didTapDepositButton() {
        deposit()
    }
    
    func didTapWithdrawButton() {
        withdraw()
    }
}

extension AccountInfoViewModel: AccountMakeProgramProtocol {
    func didTapMakeProgramButton() {
        makeProgram { (id) in
            
        }
    }
}

extension AccountInfoViewModel: AccountMakeFollowProtocol {
    func didTapMakeFollowButton() {
        makeFollow { (id) in
            
        }
    }
}

extension AccountInfoViewModel: AccountSubscriptionsProtocol {
    func didTapDetailsButton() {
        showSubscriptionDetails()
    }
}

extension AccountInfoViewModel: InvestNowProtocol {
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
        
//        invest()
    }
}

class OldDetailInfoViewModel: ViewModelWithListProtocol {
    enum RowType {
        case details
        case creationDate
        case leverage
        case currency
        case actions
    }
    
    var title = "Info"
    
    private var rows: [RowType] = []
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    //Models
    var assetId: String?
    var dashboardTradingAsset: DashboardTradingAsset?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DefaultTableViewCellViewModel.self,
                DetailTradingAccountTableViewCellViewModel.self,
                TradingAccountActionsTableViewCellViewModel.self]
    }
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: Router?, delegate: BaseTableViewProtocol?, dashboardTradingAsset: DashboardTradingAsset?) {
        self.delegate = delegate
        self.router = router
        self.assetId = dashboardTradingAsset?.id?.uuidString
        self.dashboardTradingAsset = dashboardTradingAsset
        
        if let type = dashboardTradingAsset?.accountInfo?.type {
            switch type {
            case .externalTradingAccount:
                rows = [.details, .creationDate]
            case .tradingAccount:
                rows = [.details, .creationDate, .leverage, .currency, .actions]
            default:
                break
            }
        }
    }
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    private func reloadRow(_ row: RowType) {
        let reloadRow = rows.firstIndex(of: row) ?? 0
        delegate?.didReload(IndexPath(row: reloadRow, section: 0))
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = rows[indexPath.row]
        switch type {
        case .details:
            guard let dashboardTradingAsset = dashboardTradingAsset else { return nil }
            return DetailTradingAccountTableViewCellViewModel(dashboardTradingAsset: dashboardTradingAsset)
        case .creationDate:
            guard let creationDate = dashboardTradingAsset?.accountInfo?.creationDate else { return nil }
            return DefaultTableViewCellViewModel(title: "Creation date", subtitle: creationDate.dateAndTimeToString())
        case .leverage:
            guard let leverage = dashboardTradingAsset?.accountInfo?.leverage?.toString() else { return nil }
            return DefaultTableViewCellViewModel(title: "Leverage", subtitle: "1:\(leverage)")
        case .currency:
            guard let currency = dashboardTradingAsset?.accountInfo?.currency?.rawValue else { return nil }
            return DefaultTableViewCellViewModel(title: "Currency", subtitle: currency)
        case .actions:
            return TradingAccountActionsTableViewCellViewModel(delegate: self)
        }
    }
    
    func modelsCount() -> Int {
        return rows.count
    }
    
    func didSelect(at indexPath: IndexPath) {
        
    }
}

extension OldDetailInfoViewModel: TradingAccountActionsProtocol {
    func didTapDepositButton() {
        
    }
    
    func didTapWithdrawButton() {
        
    }
}
