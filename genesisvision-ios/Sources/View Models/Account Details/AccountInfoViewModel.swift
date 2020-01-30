//
//  AccountInfoViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.20.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class AccountInfoViewModel: ViewModelWithListProtocol {
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
    var canPullToRefresh: Bool = true
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    private var router: AccountInfoRouter
    
    var chartDurationType: ChartDurationType = .all
    var assetId: String!
    
    private var equityChart: [SimpleChartPoint]?
    public private(set) var tradingAccounts: ItemsViewModelTradingAccountDetails?
    public private(set) var signalSubscription: SignalSubscription?
    public private(set) var accountDetailsFull: PrivateTradingAccountFull? {
        didSet {
            router.accountViewController.viewModel.accountDetailsFull = accountDetailsFull
            router.accountViewController.didReloadData()
            updateSections()
        }
    }
    public private(set) var programDetailsFull: ProgramDetailsFull? {
        didSet {
            updateSections()
        }
    }
    public private(set) var followDetailsFull: FollowDetailsFull? {
        didSet {
            updateSections()
        }
    }
    
    private var sections: [SectionType] = []
    var viewModels: [CellViewAnyModel] = []
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DetailStatisticsTableViewCellViewModel.self,
                ProgramYourInvestmentTableViewCellViewModel.self,
                ProgramPeriodTableViewCellViewModel.self,
                ProgramInfoTableViewCellViewModel.self,
                FollowInfoTableViewCellViewModel.self]
    }
    weak var delegate: BaseTableViewProtocol?
    // MARK: - Init
    init(withRouter router: AccountInfoRouter, assetId: String? = nil, delegate: BaseTableViewProtocol? = nil) {
        self.router = router

        if let assetId = assetId {
            self.assetId = assetId
        }
        
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
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
        guard accountDetailsFull != nil else { return }
        sections.append(.account)
        sections.append(.yourDeposit)

        delegate?.didReload()
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
            return DetailStatisticsTableViewCellViewModel(details: accountDetailsFull)
        case .yourDeposit:
            return ProgramYourInvestmentTableViewCellViewModel(details: accountDetailsFull, yourInvestmentProtocol: self)
        case .makeProgram:
            guard let programDetailsFull = programDetailsFull else { return nil }
            return ProgramInfoTableViewCellViewModel(asset: programDetailsFull, assetId: accountDetailsFull?.id?.uuidString, delegate: self)
        case .makeFollow:
            guard let followDetailsFull = followDetailsFull else { return nil }
            return FollowInfoTableViewCellViewModel(asset: followDetailsFull, assetId: accountDetailsFull?.id?.uuidString, delegate: self)
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
            completion(.success)
        }, errorCompletion: completion)
    }
}
extension AccountInfoViewModel: TradingInfoViewProtocol {
    func didTapManageAction(_ assetType: AssetType) {
        switch assetType {
        case .program:
            makeProgram { [weak self] (id) in
                self?.didReloadData()
            }
        case .follow:
            makeFollow { [weak self] (id) in
                self?.didReloadData()
            }
        default:
            break
        }
    }
    
    func didTapMainAction(_ assetType: AssetType) {
        switch assetType {
        case .program:
            makeProgram { [weak self] (id) in
                self?.didReloadData()
            }
        case .follow:
            makeFollow { [weak self] (id) in
                self?.didReloadData()
            }
        default:
            break
        }
    }
}
extension AccountInfoViewModel: YourInvestmentProtocol {
    func didTapDepositButton() {
        deposit()
    }
    
    func didTapWithdrawButton() {
        withdraw()
    }
}
extension AccountInfoViewModel: ReloadDataProtocol {
    func didReloadData() {
        fetch { [weak self] (result) in
            self?.delegate?.didReload()
        }
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
