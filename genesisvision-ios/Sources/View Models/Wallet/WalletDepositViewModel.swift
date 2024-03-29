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
    
    var selectedCurrency: Currency = .gvt
    var walletCurrencyDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var walletSummary: WalletSummary?
    var selectedWallet: WalletData? {
        didSet {
            guard let selectedWallet = selectedWallet, let address = selectedWallet.depositAddresses?.first?.address else { return }
            
            self.address = address
        }
    }
    
    // MARK: - Init
    init(withRouter router: WalletDepositRouter, currency: CurrencyType, walletSummary: WalletSummary?) {
        self.router = router
        self.walletSummary = walletSummary
        
        setup(currency: currency)
    }
    
    private func setup(currency: CurrencyType) {
        if let selectedCurrency = Currency(rawValue: currency.rawValue) {
            self.selectedCurrency = selectedCurrency
            updateSelectedCurrency(selectedCurrency)
        }
    }
    
    private func updateSelectedCurrency(_ selectedCurrency: Currency) {
        self.selectedWallet = walletSummary?.wallets?.first(where: { $0.currency == selectedCurrency })
        if let wallets = walletSummary?.wallets {
            self.walletCurrencyDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
        }
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
        guard let walletSummary = walletSummary,
            let wallets = walletSummary.wallets else { return }
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
