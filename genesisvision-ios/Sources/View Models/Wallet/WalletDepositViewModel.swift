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
    
    var walletsInfo: WalletsInfo? {
        didSet {
            self.selectedWallet = walletsInfo?.wallets?.first
        }
    }
    var selectedWallet: WalletInfo? {
        didSet {
            guard let selectedWallet = selectedWallet,
                let address = selectedWallet.address
                else { return }
            
            self.address = address
        }
    }
    
    var selectedWalletCurrencyIndex: Int = 0
    
    
    // MARK: - Init
    init(withRouter router: WalletDepositRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyIndex(_ selectedIndex: Int) {
        guard let withdrawalSummary = walletsInfo,
            let wallets = withdrawalSummary.wallets else { return }
        selectedWallet = wallets[selectedIndex]
        selectedWalletCurrencyIndex = selectedIndex
    }
    
    
    // MARK: - Picker View Values
    func walletCurrencyValues() -> [String] {
        guard let withdrawalSummary = walletsInfo,
            let wallets = withdrawalSummary.wallets else {
                return []
        }
        
        return wallets.map {
            if let description = $0.description, let currency = $0.currency?.rawValue {
                return description + " | " + currency
            }
            
            return ""
        }
    }
    
    func getInfo(completion: @escaping CompletionBlock) {
        WalletDataProvider.getWalletAddresses(completion: { [weak self] (walletsInfo) in
            guard let walletsInfo = walletsInfo else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.walletsInfo = walletsInfo
            completion(.success)
            }, errorCompletion: completion)
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

