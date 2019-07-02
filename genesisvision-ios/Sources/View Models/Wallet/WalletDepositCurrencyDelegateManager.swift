//
//  WalletDepositCurrencyDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 01/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class WalletDepositCurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource, CurrencyDelegateManagerProtocol {
    // MARK: - Variables
    weak var currencyDelegate: WalletDepositCurrencyDelegateManagerProtocol?
    
    var tableView: UITableView?
    var wallets: [WalletData] = []
    var selectedIndex: Int = 0
    var selected: WalletData?
    
    var walletId: Int = 0
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    init(_ wallets: [WalletData]) {
        super.init()
        
        self.wallets = wallets
    }
    
    func updateSelectedIndex() {
        self.selectedIndex = wallets.firstIndex(where: { return $0.currency == self.selected?.currency } ) ?? 0
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selected = wallets[indexPath.row]
        
        currencyDelegate?.didSelectWallet(at: indexPath, walletId: walletId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCurrencyTableViewCell", for: indexPath) as? WalletCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let isSelected = indexPath.row == selectedIndex
        let wallet = wallets[indexPath.row]
        cell.configure(wallet, selected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}
