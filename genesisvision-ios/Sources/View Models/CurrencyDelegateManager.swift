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
    
    var tableView: UITableView?
    var rates: [RateItem] = []
    
    var selectedRate: RateItem?
    var selectedIndex: Int = 0
    
    var currencyCellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        AuthManager.getSavedRates { (rates) in
            guard let rates = rates else { return }
            self.rates = rates
            
            self.updateSelectedIndex()
            
//            self.tableView?.reloadData()
        }
    }
    
    func updateSelectedIndex() {
        let selectedCurrency = getSelectedCurrency()
        self.selectedIndex = rates.firstIndex(where: { return $0.currency?.rawValue == selectedCurrency } ) ?? 0
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedCurrency = rates[indexPath.row].currency?.rawValue {
            updateSelectedCurrency(selectedCurrency)
        }
        
        currencyDelegate?.didSelectCurrency(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCurrencyTableViewCell", for: indexPath) as? DashboardCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let isSelected = indexPath.row == selectedIndex
        let rate = rates[indexPath.row]
        let currencyValue = rate.currency?.rawValue ?? ""
        let currencyRate = rate.rate ?? 0.0

        cell.configure(currencyValue: currencyValue, currencyRate: currencyRate, selected: isSelected)
        
        return cell
    }
}

