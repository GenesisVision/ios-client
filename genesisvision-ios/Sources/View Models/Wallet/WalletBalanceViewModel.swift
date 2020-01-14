//
//  WalletBalanceViewModel.swift
//  genesisvision-ios
//
//  Created by George on 11/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class WalletBalanceViewModel {
    enum SectionType {
        case balance
    }
    
    // MARK: - Variables
    var title = "Balance"
    
    private var sections: [SectionType] = [.balance]
    
    var router: WalletRouter!
    
    var wallet: WalletData?
    var account: TradingAccountDetails?
    
    var walletType: WalletType
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    var viewModels = [WalletBalanceTableViewCellViewModel]()
    
    init(withRouter router: WalletRouter, reloadDataProtocol: ReloadDataProtocol?, wallet: WalletData? = nil, account: TradingAccountDetails? = nil) {
        if let wallet = wallet {
            self.walletType = .wallet
            self.wallet = wallet
        } else {
            self.walletType = .all
        }
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
    }
    
    func fetch() {
        switch walletType {
        case .wallet:
            self.viewModels = [WalletBalanceTableViewCellViewModel.init(type: .total, grandTotal: nil, selectedWallet: wallet),
                               WalletBalanceTableViewCellViewModel.init(type: .available, grandTotal: nil, selectedWallet: wallet),
                               WalletBalanceTableViewCellViewModel.init(type: .invested, grandTotal: nil, selectedWallet: wallet),
                               WalletBalanceTableViewCellViewModel.init(type: .trading, grandTotal: nil, selectedWallet: wallet)]
            self.reloadDataProtocol?.didReloadData()
        default:
            AuthManager.getWallet(with: getPlatformCurrencyType(), completion: { [weak self] (wallet) in
                if let walletTabmanViewModel = self?.router.walletTabmanViewController?.viewModel {
                    walletTabmanViewModel.multiWallet = wallet
                }
                
                guard let grandTotal = wallet?.grandTotal else { return }
                self?.viewModels = [WalletBalanceTableViewCellViewModel(type: .total, grandTotal: grandTotal, selectedWallet: nil),
                                    WalletBalanceTableViewCellViewModel(type: .available, grandTotal: grandTotal, selectedWallet: nil),
                                    WalletBalanceTableViewCellViewModel(type: .invested, grandTotal: grandTotal, selectedWallet: nil),
                                    WalletBalanceTableViewCellViewModel(type: .trading, grandTotal: grandTotal, selectedWallet: nil)]
                
                self?.reloadDataProtocol?.didReloadData()
            }) { (result) in
                print("ERROR")
            }
        }
    }
}

extension WalletBalanceViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletBalanceTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return modelsCount() > 0 ? sections.count : 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
    
    func model(for indexPath: IndexPath) -> WalletBalanceTableViewCellViewModel? {
        return viewModels[indexPath.row]
    }
}

// MARK: - Navigation
extension WalletBalanceViewModel {
    func withdraw() {
        switch walletType {
        case .wallet:
            if let currency = wallet?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
                router.show(routeType: .withdraw(currencyType: currencyType))
            }
        default:
            break
        }
    }
    
    func deposit() {
        switch walletType {
        case .wallet:
            if let currency = wallet?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let multiWallet = router.walletTabmanViewController?.viewModel?.multiWallet {
                router.show(routeType: .deposit(currencyType: currencyType, walletSummary: multiWallet))
            }
        default:
            break
        }
    }
    
    func transfer() {
        if let multiWallet = router.walletTabmanViewController?.viewModel?.multiWallet {
            router.show(routeType: .transfer(from: .gvt, to: .btc, walletSummary: multiWallet))
        }
    }
}

extension WalletBalanceViewModel {
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

