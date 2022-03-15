//
//  WalletBlockchainDelegateManager.swift
//  genesisvision-ios
//
//  Created by Gregory on 14.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit


protocol WalletBlockchainDelegateManagerProtocol: AnyObject {
    func didSelectAdress(at indexPath: IndexPath)
}

final class WalletBlockchainDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var addressDelegate: WalletBlockchainDelegateManagerProtocol?
    
    var tableView: UITableView?
    var depositAddresses: [WalletDepositData] = []
    var selectedIndex: Int = 0
    var selectedAdress: WalletDepositData?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SelectableTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    init(_ depositAddresses: [WalletDepositData]) {
        super.init()
        
        self.depositAddresses = depositAddresses
    }
    
    func updateSelectedIndex() {
        self.selectedIndex = depositAddresses.firstIndex(where: { return $0.blockchainTitle == self.selectedAdress?.blockchainTitle } ) ?? 0
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedAdress = depositAddresses[indexPath.row]
        
        addressDelegate?.didSelectAdress(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let wallet = depositAddresses[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
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
