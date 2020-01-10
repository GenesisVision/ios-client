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
                    viewModels.append(WalletTableViewCellViewModel.init(wallet: wallet))
                }
            }
        }
    }
    
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
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
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
        if let model = model(at: indexPath) as? WalletTableViewCellViewModel {
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
            self?.reloadDataProtocol?.didReloadData()
        }) { (result) in
            print("ERROR")
        }
    }
}
