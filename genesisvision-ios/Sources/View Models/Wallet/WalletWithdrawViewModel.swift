//
//  WalletWithdrawViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class WalletWithdrawViewModel {
    // MARK: - Variables
    var title: String = "Withdraw"
    
    private weak var walletProtocol: WalletProtocol?
    
    var labelPlaceholder: String = "0"
    
    var withdrawalSummary: WithdrawalSummary? {
        didSet {
            updateSelectedCurrency(self.selectedCurrency)
        }
    }
    var selectedWallet: WalletWithdrawalInfo?

    private var router: WalletWithdrawRouter!
    
    var selectedCurrency: WalletWithdrawalInfo.Currency = .gvt
    var walletCurrencyDelegateManager: WalletCurrencyDelegateManager?
    
    // MARK: - Init
    init(withRouter router: WalletWithdrawRouter, walletProtocol: WalletProtocol, currency: CurrencyType) {
        self.router = router
        self.walletProtocol = walletProtocol
        
        setup(currency)
    }
    
    private func updateSelectedCurrency(_ selectedCurrency: WalletWithdrawalInfo.Currency) {
        self.selectedWallet = withdrawalSummary?.wallets?.first(where: { $0.currency == selectedCurrency })
        if let wallets = withdrawalSummary?.wallets {
            self.walletCurrencyDelegateManager = WalletCurrencyDelegateManager(wallets)
        }
    }
    
    private func setup(_ currency: CurrencyType) {
        if let selectedCurrency = WalletWithdrawalInfo.Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
            updateSelectedCurrency(selectedCurrency)
        }
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
        guard let withdrawalSummary = withdrawalSummary,
            let wallets = withdrawalSummary.wallets else { return }
        selectedWallet = wallets[selectedIndex]
    }
    
    func getInfo(completion: @escaping CompletionBlock) {
        WalletDataProvider.getWithdrawInfo(completion: { [weak self] (withdrawalSummary) in
            guard let withdrawalSummary = withdrawalSummary else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.withdrawalSummary = withdrawalSummary
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, address: String, currency: CreateWithdrawalRequestModel.Currency, twoFactorCode: String, completion: @escaping CompletionBlock) {
        WalletDataProvider.createWithdrawalRequest(with: amount, address: address, currency: currency, twoFactorCode: twoFactorCode, completion: completion)
    }
    
    func readQRCode(completion: @escaping CompletionBlock) {
        router.show(routeType: .readQRCode)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}

import UIKit

protocol WalletCurrencyDelegateManagerProtocol: class {
    func didSelectWallet(at indexPath: IndexPath)
}

final class WalletCurrencyDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    weak var currencyDelegate: WalletCurrencyDelegateManagerProtocol?
    
    var tableView: UITableView?
    var wallets: [WalletWithdrawalInfo] = []
    var selectedIndex: Int = 0
    var selectedWallet: WalletWithdrawalInfo?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Lifecycle
    init(_ wallets: [WalletWithdrawalInfo]) {
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
        
        currencyDelegate?.didSelectWallet(at: indexPath)
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
