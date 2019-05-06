//
//  WalletDepositViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class WalletDepositViewModel {
    // MARK: - Variables
    var title: String = "Add funds"
    var labelPlaceholder: String = "0"
    let successText = String.Info.walletCopyAddress
    private var router: WalletDepositRouter!
    
    private var address: String = "" {
        didSet {
            if var qrCode = QRCode(address) {
                qrCode.size = CGSize(width: 300, height: 300)
                qrCode.color = CIColor(cgColor: UIColor.BaseView.bg.cgColor)
                qrCode.backgroundColor = CIColor(cgColor: UIColor.Cell.title.cgColor)
                qrImage = qrCode.image
            }
        }
    }
    
    private var qrImage: UIImage?
    
    var selectedCurrency: WalletData.Currency = .gvt
    var walletCurrencyDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var walletMultiSummary: WalletMultiSummary?
    var selectedWallet: WalletData? {
        didSet {
            guard let selectedWallet = selectedWallet, let address = selectedWallet.depositAddress else { return }
            
            self.address = address
        }
    }
    
    // MARK: - Init
    init(withRouter router: WalletDepositRouter, currency: CurrencyType, walletMultiSummary: WalletMultiSummary?) {
        self.router = router
        self.walletMultiSummary = walletMultiSummary
        
        setup(currency: currency)
    }
    
    private func setup(currency: CurrencyType) {
        if let selectedCurrency = WalletData.Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
            updateSelectedCurrency(selectedCurrency)
        }
    }
    
    private func updateSelectedCurrency(_ selectedCurrency: WalletData.Currency) {
        self.selectedWallet = walletMultiSummary?.wallets?.first(where: { $0.currency == selectedCurrency })
        if let wallets = walletMultiSummary?.wallets {
            self.walletCurrencyDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
        }
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
        guard let walletMultiSummary = walletMultiSummary,
            let wallets = walletMultiSummary.wallets else { return }
        selectedWallet = wallets[selectedIndex]
    }
    
    func getAddress() -> String {
        return address
    }
    
    func getQRImage() -> UIImage {
        return qrImage ?? UIImage.placeholder
    }
    
    // MARK: - Navigation
    func copy(completion: @escaping CompletionBlock) {
        UIPasteboard.general.string = address
        completion(.success)
    }
}

protocol WalletDepositCurrencyDelegateManagerProtocol: class {
    func didSelectWallet(at indexPath: IndexPath, walletId: Int)
}

final class WalletDepositCurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var currencyDelegate: WalletDepositCurrencyDelegateManagerProtocol?
    
    var tableView: UITableView?
    var wallets: [WalletData] = []
    var selectedIndex: Int = 0
    var selectedWallet: WalletData?
    
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
        self.selectedIndex = wallets.firstIndex(where: { return $0.currency == self.selectedWallet?.currency } ) ?? 0
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedWallet = wallets[indexPath.row]
        
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
