//
//  CurrencyDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

protocol CurrencyDelegateManagerProtocol: class {
    func didSelectCurrency(at indexPath: IndexPath)
}

final class CurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var currencyDelegate: CurrencyDelegateManagerProtocol?
    
    var currencyValues: [String] = ["USD", "EUR", "BTC"]
    var rateValues: [Double] = [6.3, 5.5, 0.0002918]
    
    var selectedCurrency: String!
    
    var currencyCellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        selectedCurrency = getSelectedCurrency()
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCurrency = currencyValues[indexPath.row]
        updateSelectedCurrency(selectedCurrency)
        
        currencyDelegate?.didSelectCurrency(at: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCurrencyTableViewCell", for: indexPath) as? DashboardCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let currency = currencyValues[indexPath.row]
        let rate = "1 GVT = \(rateValues[indexPath.row]) " + currency
        let isSelected = currency == selectedCurrency
        
        cell.isSelected = isSelected
        cell.configure(title: currency, rate: rate, selected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath) as? DashboardCurrencyTableViewCell, cell.accessoryType == .none {
            cell.currencyTitleLabel.textColor = UIColor.Cell.title
            cell.currencyRateLabel.textColor = UIColor.Cell.title
            cell.contentView.backgroundColor = UIColor.Cell.title.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath) as? DashboardCurrencyTableViewCell, cell.accessoryType == .none {
            cell.currencyTitleLabel.textColor = UIColor.Cell.subtitle
            cell.currencyRateLabel.textColor = UIColor.Cell.subtitle
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}

