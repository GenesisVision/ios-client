//
//  AccountViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class AccountViewController: BaseTabmanViewController<AccountTabmanViewModel> {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotification(notification:)), name: .updateTradingAccountViewController, object: nil)
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    @objc private func updateNotification(notification: Notification) {
        guard let assetId = notification.userInfo?["assetId"] as? String, assetId == viewModel.assetId else { return }
        viewModel.updateViewControllers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateTradingAccountViewController, object: nil)
    }
}
extension AccountViewController: ReloadDataProtocol {
    func didReloadData() {
        self.title = viewModel.title
    }
}
final class AccountTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    enum TabType: String {
        case info = "Info"
        case balance = "Balance"
        case profit = "Profit"
        case openPosition = "Open position"
        case trades = "Trades"
    }
    
    var tabTypes: [TabType] = [.info, .profit, .balance, .openPosition, .trades]
    var controllers = [TabType : UIViewController]()
    
    var assetId: String?
    
    var accountDetailsFull: PrivateTradingAccountFull? {
        didSet {
            title = accountDetailsFull?.publicInfo?.title ?? ""
        }
    }
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        self.router = router
        self.assetId = assetId
        
        font = UIFont.getFont(.semibold, size: 16)
        
        self.dataSource = PageboyDataSource(self)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        let currency = getPlatformCurrencyType()
        
        guard let router = self.router as? AccountRouter, let assetId = self.assetId else { return nil }
        
        switch type {
        case .info:
            return router.getInfo(with: assetId)
        case .balance:
            let viewModel = AccountBalanceViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.accountViewController)
            
            return router.getBalanceViewController(with: viewModel)
        case .profit:
            let currency = accountDetailsFull?.tradingAccountInfo?.currency?.rawValue
            let currencyType = CurrencyType(rawValue: currency ?? "USD")
            let viewModel = AccountProfitViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.accountViewController, currency: currencyType)
            
            return router.getProfitViewController(with: viewModel)
        case .trades:
            return router.getTrades(with: assetId, currencyType: currency)
        case .openPosition:
            return router.getTradesOpen(with: assetId, currencyType: currency)
        }
    }
    
    func updateViewControllers() {
        controllers.forEach { (type, viewController) in
            switch type {
            case .info:
                guard let infoViewController = viewController as? AccountInfoViewController else { return }
                infoViewController.fetch()
            case .balance:
                guard let balanceViewController = viewController as? BalanceViewController else { return }
                balanceViewController.fetch()
            case .profit:
                guard let profitViewController = viewController as? ProfitViewController else { return }
                profitViewController.fetch()
            case .openPosition:
                guard let tradesViewController = viewController as? TradesViewController else { return }
                tradesViewController.fetch()
            case .trades:
                guard let tradesViewController = viewController as? TradesViewController else { return }
                tradesViewController.fetch()
            }
        }
        
    }
}

extension AccountTabmanViewModel: TabmanDataSourceProtocol {
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
