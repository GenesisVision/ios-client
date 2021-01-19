//
//  WalletListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class WalletListViewModel {
    enum SectionType {
        case header
        case wallets
    }
    
    // MARK: - Variables
    var title: String = "My wallets"
    
    var wallet: WalletSummary? {
        didSet {
            if let wallet = wallet, let wallets = wallet.wallets {
                walletType = .wallet
                viewModels.removeAll()
                wallets.forEach { (wallet) in
                    let amountInPlatformCurrency = getAmountForPlatformCurrency(fromAmount: wallet.available, fromCurrency: wallet.currency?.rawValue)
                    viewModels.append(WalletTableViewCellViewModel.init(wallet: wallet, totalAmountInPlatformCurrency: amountInPlatformCurrency))
                }
            }
        }
    }
    
    private var rates: RatesModel?
    
    private var sections: [SectionType] = [.wallets]
    
    var walletType: WalletType = .all
    
    private var router: WalletRouter!
    private var viewModels = [WalletTableViewCellViewModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Init
    init(withRouter router: WalletRouter, reloadDataProtocol: ReloadDataProtocol? = nil) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
    }
    
    private func getAmountForPlatformCurrency(fromAmount: Double?, fromCurrency: String?) -> Double? {
        guard let fromAmount = fromAmount,
              let fromCurrency = fromCurrency,
              let rates = rates?.rates,
              let rate = rates[getPlatformCurrencyType().rawValue]?.first(where: {$0.currency == fromCurrency })?.rate else { return nil }
        return fromAmount/rate
    }
}

// MARK: - TableView
extension WalletListViewModel {
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 0
        case .wallets:
            return viewModels.count
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .wallets:
            return "Wallets"
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .header:
            return 0.0
        case .wallets:
            return 70.0
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return nil
        case .wallets:
            return viewModels[indexPath.row]
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        fetch()
    }
}

// MARK: - Navigation
extension WalletListViewModel {
    func showWallet(at indexPath: IndexPath) {
        if let model = model(for: indexPath) as? WalletTableViewCellViewModel {
            let walletViewController = WalletViewController()
            walletViewController.viewModel = WalletTabmanViewModel(withRouter: router, wallet: model.wallet, walletType: .wallet)
            walletViewController.hidesBottomBarWhenPushed = true
            router.walletTabmanViewController?.push(viewController: walletViewController)
        }
    }
    
    func transfer() {
        router.show(routeType: .transfer(from: .gvt, to: .btc, walletSummary: wallet))
    }
}

extension WalletListViewModel {
    func logoImageName() -> String {
        let imageName = "img_wallet_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "You don’t have any wallets yet"
    }
    
    func noDataImageName() -> String? {
        return nil
    }
    
    func noDataButtonTitle() -> String {
        let text = ""
        return text
    }
}

// MARK: - Fetch
extension WalletListViewModel {
    func fetch() {
        AuthManager.getWallet(completion: { [weak self] (wallet) in
            guard let wallet = wallet else { return }
            self?.wallet = wallet
            let walletsList = wallet.wallets?.map({ (wallet) -> String? in
                guard let currency = wallet.currency?.rawValue else { return nil }
                return currency
            }).compactMap({ $0 }) ?? [Currency.btc.rawValue, Currency.eth.rawValue, Currency.gvt.rawValue, Currency.usdt.rawValue, Currency.usdc.rawValue]
            RateDataProvider.getRates(from: [getPlatformCurrencyType().rawValue], to: walletsList, completion: { [weak self] (ratesModel) in
                self?.rates = ratesModel
                self?.reloadDataProtocol?.didReloadData()
            }) { _ in }
        }) { _ in }
    }
}
