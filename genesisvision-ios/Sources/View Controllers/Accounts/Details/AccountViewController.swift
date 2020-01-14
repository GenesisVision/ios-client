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
        
        showProgressHUD()
        setup()
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            self?.reloadData()
            self?.title = self?.viewModel.title
        }
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
extension AccountViewController: ReloadDataProtocol {
    func didReloadData() {
        
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
    
    var accountDetailsFull: PrivateTradingAccountFull?
    
    // MARK: - Init
    init(withRouter router: Router, assetId: String) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.assetId = assetId
        self.title = ""
    
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
            guard let currency = accountDetailsFull?.tradingAccountInfo?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) else { return nil }
            let viewModel = AccountProfitViewModel(withRouter: router, assetId: assetId, reloadDataProtocol: router.accountViewController, currency: currencyType)
            
            return router.getProfitViewController(with: viewModel)
        case .trades:
            return router.getTrades(with: assetId, currencyType: currency)
        case .openPosition:
            return router.getTradesOpen(with: assetId, currencyType: currency)
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

// MARK: - Actions
extension AccountTabmanViewModel {
    // MARK: - Public methods
    func fetch(_ completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId else { return }
        AccountsDataProvider.get(assetId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.accountDetailsFull = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
}
