//
//  WalletTransferViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

final class WalletTransferViewModel {
    // MARK: - Variables
    var title: String = "Transfer"
    var disclaimer = "The funds will be converted according to the current market price (Market order on Binance)."
    var labelPlaceholder: String = "0"
    
    private weak var walletProtocol: WalletProtocol?
    
    var walletSummary: WalletSummary?
    
    //from
    var selectedWalletFromDelegateManager: WalletDepositCurrencyDelegateManager?
    //to
    var selectedWalletToDelegateManager: WalletDepositCurrencyDelegateManager?
    
    var rate: Double = 0.0
    
    private var router: WalletRouter!
    
    // MARK: - Init
    init(withRouter router: WalletRouter, walletProtocol: WalletProtocol, walletSummary: WalletSummary?) {
        self.router = router
        self.walletProtocol = walletProtocol
        self.walletSummary = walletSummary
        
        setup()
    }
    
    private func setup() {
        if let wallets = walletSummary?.wallets, wallets.count > 1 {
            self.selectedWalletFromDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
            self.selectedWalletFromDelegateManager?.walletId = 0
            self.selectedWalletFromDelegateManager?.selected = walletSummary?.wallets?[0]
            self.selectedWalletFromDelegateManager?.selectedIndex = 0
            
            self.selectedWalletToDelegateManager = WalletDepositCurrencyDelegateManager(wallets)
            self.selectedWalletToDelegateManager?.walletId = 1
            self.selectedWalletToDelegateManager?.selected = walletSummary?.wallets?[1]
            self.selectedWalletToDelegateManager?.selectedIndex = 1
        }
        
        updateRate { [weak self] (result) in
            //TODO:
            self?.walletProtocol?.didUpdateData()
        }
    }
    
    
    private func updateRate(completion: @escaping CompletionBlock) {
        guard let from = selectedWalletFromDelegateManager?.selected, let to = selectedWalletToDelegateManager?.selected else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        RateDataProvider.getRate(from: from.currency?.rawValue ?? "", to: to.currency?.rawValue ?? "", completion: { [weak self] (rate) in
            self?.rate = rate?.rate ?? 0.0
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Public methods
    func updateWalletCurrencyFromIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletSummary = walletSummary,
            let wallets = walletSummary.wallets else { return }
        
        selectedWalletFromDelegateManager?.selectedIndex = selectedIndex
        
        selectedWalletFromDelegateManager?.selected = wallets[selectedWalletFromDelegateManager?.selectedIndex ?? 0]
        updateRate(completion: completion)
    }
    
    func updateWalletCurrencyToIndex(_ selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let walletSummary = walletSummary,
            let wallets = walletSummary.wallets else { return }
        
        selectedWalletToDelegateManager?.selectedIndex = selectedIndex
        
        selectedWalletToDelegateManager?.selected = wallets[selectedWalletToDelegateManager?.selectedIndex ?? 0]
        updateRate(completion: completion)
    }
    
    // MARK: - Navigation
    func transfer(with amount: Double, completion: @escaping CompletionBlock) {
        guard let sourceId = selectedWalletFromDelegateManager?.selected?._id, let destinationId = selectedWalletToDelegateManager?.selected?._id else { return }
        
        WalletDataProvider.transfer(sourceId: sourceId, destinationId: destinationId, amount: amount, completion: completion)
    }
    
    func goToBack() {
        walletProtocol?.didUpdateData()
        router.goToBack()
    }
}
