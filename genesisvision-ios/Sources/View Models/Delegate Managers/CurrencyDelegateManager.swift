//
//  CurrencyDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

protocol CurrencyDelegateManagerDelegate: class {
    func didSelectCurrency(at indexPath: IndexPath)
}

final class CurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    
    weak var currencyDelegate: CurrencyDelegateManagerDelegate?
    
    var tableView: UITableView?
    var currencies: [PlatformCurrencyInfo] = []
    
    var selectedRate: RateItem?
    var selectedIndex: Int = 0
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
    }
    
    func loadCurrencies() {
        PlatformManager.shared.getPlatformInfo { (platformInfo) in
            guard let platformInfo = platformInfo else { return }
            
            if let platformCurrencies = platformInfo.commonInfo?.platformCurrencies {
                self.currencies = platformCurrencies
                self.updateSelectedIndex()
                self.tableView?.reloadData()
            }
        }
    }
    
    func updateSelectedIndex() {
        self.selectedIndex = currencies.firstIndex(where: { return $0.name == selectedPlatformCurrency } ) ?? 0
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currencyDelegate?.didSelectCurrency(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCurrencyTableViewCell", for: indexPath) as? DashboardCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        //FIXME: 
//        let isSelected = indexPath.row == selectedIndex
//        let currency = currencies[indexPath.row]
//        let currencyValue = currency.name ?? ""
//        let currencyRate = currency.rateToGvt ?? 0.0
//        let subtitle = "1 GVT = \(currencyRate) " + currencyValue
        
//        cell.configure(title: currencyValue, subtitle: subtitle, selected: isSelected)
        
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

