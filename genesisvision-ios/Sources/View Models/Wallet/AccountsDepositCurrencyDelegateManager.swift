//
//  AccountsDepositCurrencyDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 01/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

final class AccountsDepositCurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource, CurrencyDelegateManagerProtocol {
    // MARK: - Variables
    weak var currencyDelegate: WalletDelegateManagerProtocol?
    
    var tableView: UITableView?
    var accounts: [CopyTradingAccountInfo] = []
    var selectedIndex: Int = 0
    var selected: CopyTradingAccountInfo?
    
    var walletId: Int = 0
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SelectableTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    init(_ accounts: [CopyTradingAccountInfo]) {
        super.init()
        
        self.accounts = accounts
    }
    
    func updateSelectedIndex() {
        self.selectedIndex = accounts.firstIndex(where: { return $0.currency == self.selected?.currency } ) ?? 0
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selected = accounts[indexPath.row]
        
        currencyDelegate?.didSelectWallet(at: indexPath, walletId: walletId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let account = accounts[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(account, selected: isSelected)
        
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



