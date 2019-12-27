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
    var dataSource: AccountDetailPageboyDataSource!
    
    var dashboardTradingAsset: DashboardTradingAsset?
    
    // MARK: - Init
    init(withRouter router: Router, dashboardTradingAsset: DashboardTradingAsset? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.dataSource = AccountDetailPageboyDataSource(router: router, dashboardTradingAsset: dashboardTradingAsset)
        self.dashboardTradingAsset = dashboardTradingAsset
        self.title = dashboardTradingAsset?.accountInfo?.title ?? ""
        
        font = UIFont.getFont(.semibold, size: 16)
        
        items = [TMBarItem(title: "Info"),
                 TMBarItem(title: "Statistics"),
                 TMBarItem(title: "Open positions"),
                 TMBarItem(title: "Trades")]
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        
    }
}

class AccountDetailPageboyDataSource: BasePageboyViewControllerDataSource {
    var dashboardTradingAsset: DashboardTradingAsset?
    
    // MARK: - Private methods
    internal override func setup(router: Router, dashboardTradingAsset: DashboardTradingAsset? = nil) {
        self.dashboardTradingAsset = dashboardTradingAsset
        
        let vc = DetailInfoViewController<DetailInfoViewModel>()
        let viewModel = DetailInfoViewModel(router, delegate: vc, dashboardTradingAsset: dashboardTradingAsset)
        vc.viewModel = viewModel
        
        controllers.append(vc)
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
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch()
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
    
    func fetch() {
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
