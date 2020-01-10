//
//  SelectableListViewModels.swift
//  genesisvision-ios
//
//  Created by George on 27.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
// MARK: - PlatformCurrencyInfo
class PlatformCurrencyListViewModel: SelectableListViewModel<PlatformCurrencyInfo> {
    var title = "Choose currency"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item.name, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.currency, index: indexPath.row)
    }
}
// MARK: - Broker
class ExchangeListViewModel: SelectableListViewModel<Broker> {
    var title = "Choose exchange"
    
    var tableView: UITableView!
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)

        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.exchange, index: indexPath.row)
    }
}
// MARK: - BrokerAccountType
class AccountTypeListViewModel: SelectableListViewModel<BrokerAccountType> {
    var title = "Choose account type"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.accountType, index: indexPath.row)
    }
}
// MARK: - String
class CurrencyListViewModel: SelectableListViewModel<String> {
    var title = "Choose currency"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.currency, index: indexPath.row)
    }
}
// MARK: - Int
class LeverageListViewModel: SelectableListViewModel<Int> {
    var title = "Choose broker's leverage"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)

        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.leverage, index: indexPath.row)
    }
}
// MARK: - TradingAccountDetails
class TradingAccountListViewModel: SelectableListViewModel<TradingAccountDetails> {
    var title = "Choose account"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.tradingAccountType, index: indexPath.row)
    }
}
// MARK: - WalletData
class FromListViewModel: SelectableListViewModel<WalletData> {
    var title = "Choose wallet"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.walletFrom, index: indexPath.row)
    }
    
    func updateSelected(_ currency: CurrencyType) {
        self.selectedIndex = items.firstIndex(where: { $0.currency?.rawValue == currency.rawValue }) ?? 0
    }
}
