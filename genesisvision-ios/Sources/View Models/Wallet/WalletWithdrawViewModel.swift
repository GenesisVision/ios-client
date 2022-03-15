//
//  WalletWithdrawViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

protocol BlockchainValueUpdateProtocol : AnyObject {
    func updateVCUI()
}

final class WalletWithdrawViewModel {
    // MARK: - Variables
    var title: String = "Withdraw"
    
    private weak var walletProtocol: WalletProtocol?
    
    weak var blockchainValueUpdateDelegate : BlockchainValueUpdateProtocol?
    
    var labelPlaceholder: String = "0"
    
    var withdrawalSummary: WithdrawalSummary? {
        didSet {
            updateSelectedCurrency(self.selectedCurrency)
        }
    }
    var walletSummary: WalletSummary?
    
    var selectedWalletData: WalletData?
    var depositAddresses: [WalletDepositData]?
    
    var selectedWallet: WalletWithdrawalInfo?

    private var router: WalletWithdrawRouter!
    
    var selectedCurrency: Currency = .gvt
    var selectedAdress : WalletDepositData?
    var walletCurrencyDelegateManager: WalletCurrencyDelegateManager?
    var walletBlockchainDelegateManager: WalletBlockchainDelegateManager?
    
    // MARK: - Init
    init(withRouter router: WalletWithdrawRouter, walletProtocol: WalletProtocol, currency: CurrencyType) {
        self.router = router
        self.walletProtocol = walletProtocol
        
        setup(currency)
    }
    
    private func updateSelectedCurrency(_ selectedCurrency: Currency) {
        self.selectedWallet = withdrawalSummary?.wallets?.first(where: { $0.currency == selectedCurrency })
        if let wallets = withdrawalSummary?.wallets {
            self.walletCurrencyDelegateManager = WalletCurrencyDelegateManager(wallets)
        }
    }
    
    private func setup(_ currency: CurrencyType) {
        if let selectedCurrency = Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
            updateSelectedCurrency(selectedCurrency)
            updateBlockchain(with: selectedCurrency)
        }
    }
    
    private func updateBlockchain(with currency: CurrencyType? = nil) {
        getWallet(with: selectedCurrency, completion: { [weak self] (wallet) in
            self?.walletSummary = wallet
            self?.selectedWalletData = wallet?.wallets?.first(where: { $0.currency == currency })
            guard let depositAddress = self?.selectedWalletData?.depositAddresses else { return }
            self?.depositAddresses = depositAddress
            self?.selectedAdress = depositAddress.first
            self?.walletBlockchainDelegateManager = WalletBlockchainDelegateManager(depositAddress)
            self?.blockchainValueUpdateDelegate?.updateVCUI()
        }, completionError: { (result) in
            print("ERROR")
        })
    }
    
    private func getWallet(with currency: CurrencyType? = nil, completion: @escaping (_ wallet: WalletSummary?) -> Void, completionError: @escaping CompletionBlock) {
        
        if let walletSummary = walletSummary {
            completion(walletSummary)
        }
        
        WalletDataProvider.get(with: currency ?? getPlatformCurrencyType(), completion: { (viewModel) in
            if viewModel != nil  {
                self.walletSummary = viewModel
            }
            
            completion(viewModel)
        }, errorCompletion: completionError)
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
        guard let withdrawalSummary = withdrawalSummary,
            let wallets = withdrawalSummary.wallets else { return }
        selectedWallet = wallets[selectedIndex]
        guard let selectedCurrency = selectedWallet?.currency else { return }
        updateBlockchain(with: selectedCurrency)
    }
    
    func updateWalletBlockchainAddressIndex(_ selectedIndex: Int) {
        guard let depositAddresses = depositAddresses else { return }
        selectedAdress = depositAddresses[selectedIndex]
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
    func withdraw(with amount: Double, address: String, currency: Currency, twoFactorCode: String, blockchain : Blockchain, completion: @escaping CompletionBlock) {
        WalletDataProvider.createWithdrawalRequest(with: amount, address: address, currency: currency, twoFactorCode: twoFactorCode, blockchain : blockchain, completion: completion)
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

protocol WalletCurrencyDelegateManagerProtocol: AnyObject {
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
        return [SelectableTableViewCellViewModel.self]
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
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let wallet = wallets[indexPath.row]
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
