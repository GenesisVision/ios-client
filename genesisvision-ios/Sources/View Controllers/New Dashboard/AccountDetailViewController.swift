//
//  AccountDetailViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class AccountDetailViewController: BaseTabmanViewController<AccountDetailTabmanViewModel> {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        reloadData()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
}

final class AccountDetailTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    enum TabType: String {
        case info = "Info"
        case profit = "Profit"
        case openPosition = "Open position"
        case trades = "Trades"
    }
    
    var tabTypes: [TabType] = [.info, .profit, .openPosition, .trades]
    var controllers = [TabType : UIViewController]()
    
    var dashboardTradingAsset: DashboardTradingAsset?
    
    // MARK: - Init
    init(withRouter router: Router, dashboardTradingAsset: DashboardTradingAsset? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
        self.dashboardTradingAsset = dashboardTradingAsset
        self.title = dashboardTradingAsset?.accountInfo?.title ?? ""
        
        font = UIFont.getFont(.semibold, size: 16)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        switch type {
        case .info:
            let vc = DetailInfoViewController<DetailInfoViewModel>()
            let viewModel = DetailInfoViewModel(router, delegate: vc, dashboardTradingAsset: dashboardTradingAsset)
            vc.viewModel = viewModel
            return vc
        case .profit:
            guard let router = self.router as? AccountRouter, let assetId = dashboardTradingAsset?.id?.uuidString else { return nil }
            return router.getProfit(with: assetId)
        case .trades:
            guard let router = self.router as? AccountRouter, let assetId = dashboardTradingAsset?.id?.uuidString else { return nil }
            return router.getTrades(with: assetId, currencyType: getPlatformCurrencyType())
        case .openPosition:
            guard let router = self.router as? AccountRouter, let assetId = dashboardTradingAsset?.id?.uuidString else { return nil }
            return router.getTradesOpen(with: assetId, currencyType: getPlatformCurrencyType())
        }
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        
    }
}

extension AccountDetailTabmanViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        return getViewController(tabTypes[index])
    }
}

// MARK: - Info VC
class DetailInfoViewController<ViewModel: ViewModelWithListProtocol>: ListViewController {
    // MARK: - Veriables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetch()
    }
    private func setup() {
        setupPullToRefresh(scrollView: tableView)
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch()
    }
    
    func fetch() {
        reloadData()
    }
}
extension DetailInfoViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("select cell \(type)")
        
    }
    
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
    }
    
    func didReload(_ indexPath: IndexPath) {
        hideHUD()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
class DetailInfoViewModel: ViewModelWithListProtocol {
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
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
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

extension DetailInfoViewModel: TradingAccountActionsProtocol {
    func didTapDepositButton() {
        
    }
    
    func didTapWithdrawButton() {
        
    }
}

class AccountRouter: TabmanRouter {
    // MARK: - Variables
    var programViewController: ProgramViewController?
    var detailInfoViewController: DetailInfoViewController<DetailInfoViewModel>?
    var tradeListViewController: AccountTradeListViewController?
    var openTradeListViewController: AccountTradeListViewController?
    
    // MARK: - Public methods
    func getInfo(with dashboardTradingAsset: DashboardTradingAsset?) -> DetailInfoViewController<DetailInfoViewModel>? {
        let vc = DetailInfoViewController<DetailInfoViewModel>()
        let viewModel = DetailInfoViewModel(self, delegate: vc, dashboardTradingAsset: dashboardTradingAsset)
        vc.viewModel = viewModel
        
        vc.hidesBottomBarWhenPushed = true
        
        detailInfoViewController = vc
        return vc
    }
    
    func getTrades(with assetId: String, currencyType: CurrencyType) -> AccountTradeListViewController? {

        let viewController = AccountTradeListViewController()
        let viewModel = AccountTradeListViewModel(self, assetId: assetId, isOpenTrades: false, currency: currencyType, delegate: viewController)
        viewController.viewModel = viewModel
        tradeListViewController = viewController
        return viewController
    }
    
    func getTradesOpen(with assetId: String, currencyType: CurrencyType) -> AccountTradeListViewController? {

        let viewController = AccountTradeListViewController()
        let viewModel = AccountTradeListViewModel(self, assetId: assetId, isOpenTrades: true, currency: currencyType, delegate: viewController)
        viewController.viewModel = viewModel
        openTradeListViewController = viewController
        return viewController
    }
    
    func getBalance(with assetId: String) -> ProgramBalanceViewController? {
//        guard let vc = currentController as? ProgramViewController else { return nil }
        
        let viewController = ProgramBalanceViewController()
//        let viewModel = ProgramBalanceViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: vc)
//        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getProfit(with assetId: String) -> ProgramProfitViewController? {
        guard let vc = currentController as? ProgramViewController else { return nil }
        
        let viewController = ProgramProfitViewController()
        let viewModel = ProgramProfitViewModel(withRouter: self, assetId: assetId, reloadDataProtocol: vc)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
