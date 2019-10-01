//
//  WalletCopytradingAccountListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class WalletCopytradingAccountListViewModel {
    enum SectionType {
        case header
        case accounts
    }
    
    // MARK: - Variables
    var title: String = "Copytrading accounts"
    var totalCount = 0
    var accounts: [CopyTradingAccountInfo]? {
        didSet {
            router.walletTabmanViewController?.viewModel?.accounts = accounts
        }
    }
    
    private var sections: [SectionType] = [.accounts]
    
    private var router: WalletRouter!
    private var viewModels = [WalletCopytradingAccountTableViewCellViewModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Init
    init(withRouter router: WalletRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        
        setup()
    }
}

// MARK: - TableView
extension WalletCopytradingAccountListViewModel {
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletCopytradingAccountTableViewCellViewModel.self]
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
        case .accounts:
            return viewModels.count
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .accounts:
            return "Copytrading accounts"
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .header:
            return 0.0
        case .accounts:
            return 70.0
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return nil
        case .accounts:
            return viewModels[indexPath.row]
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        fetch()
    }
}

// MARK: - Navigation
extension WalletCopytradingAccountListViewModel {
    func showAccount(at indexPath: IndexPath) {
        if let model = model(at: indexPath) as? WalletCopytradingAccountTableViewCellViewModel {
            let walletViewController = WalletViewController()
            walletViewController.viewModel = WalletTabmanViewModel(withRouter: router, account: model.copyTradingAccountInfo, walletType: .account)
            walletViewController.hidesBottomBarWhenPushed = true
            router.walletTabmanViewController?.push(viewController: walletViewController)
        }
    }
}

extension WalletCopytradingAccountListViewModel {
    func logoImageName() -> String {
        let imageName = "img_wallet_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "You don’t have any copytrading accounts yet"
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
extension WalletCopytradingAccountListViewModel {
    func fetch() {
        SignalDataProvider.getAccounts(completion: { [weak self] (copyTradingAccountsViewModel) in
            guard copyTradingAccountsViewModel != nil else {
                return
            }
            
            var viewModels = [WalletCopytradingAccountTableViewCellViewModel]()
            
            copyTradingAccountsViewModel?.accounts?.forEach({ (copyTradingAccountInfo) in
                let viewModel = WalletCopytradingAccountTableViewCellViewModel(copyTradingAccountInfo: copyTradingAccountInfo)
                viewModels.append(viewModel)
            })
            
            self?.accounts = copyTradingAccountsViewModel?.accounts
            self?.viewModels = viewModels
            self?.totalCount = viewModels.count
            self?.reloadDataProtocol?.didReloadData()
            }, errorCompletion: { (result) in
                print(result)
        })
    }
}


