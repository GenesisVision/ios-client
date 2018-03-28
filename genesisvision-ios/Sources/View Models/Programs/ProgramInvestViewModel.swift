//
//  ProgramInvestViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramInvestViewModel {
    // MARK: - Variables
    var title: String = "Investment"
    var investmentProgramId: String?
    private var rate: Double = 0.0
    private var balance: Double = 0.0 {
        didSet {
            self.usdBalance = balance * self.rate
        }
    }
    private var usdBalance: Double = 0.0
    
    private weak var programDetailProtocol: ProgramDetailProtocol?
    
    private var router: ProgramInvestRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInvestRouter, investmentProgramId: String, programDetailProtocol: ProgramDetailProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.programDetailProtocol = programDetailProtocol
    }
    
    // MARK: - Public methods
    func getBalanceText(completion: @escaping (_ balance: String, _ usdBalance: String) -> Void) {
        AuthManager.getSavedRate { [weak self] (value) in
            self?.rate = value
            
            AuthManager.getBalance { [weak self] (value) in
                self?.balance = value
                
                if let balanceText = self?.balance.toString(), let usdBalanceText = self?.usdBalance.toString(currency: true) {
                    completion(balanceText, usdBalanceText)
                }
            }
        }
    }
    
    func getUSDAmountText(amount: Double, completion: @escaping (_ usdAmount: String) -> Void) {
        guard self.rate > 0 else {
            AuthManager.getSavedRate { [weak self] (value) in
                self?.rate = value
                
                let amountWithRate = amount * value
                completion(amountWithRate.toString(currency: true))
            }
            
            return
        }
        
        let amountWithRate = amount * self.rate
        completion(amountWithRate.toString(currency: true))
    }
    
    // MARK: - Navigation
    func invest(with value: Double, completion: @escaping CompletionBlock) {
        apiInvest(with: value, completion: completion)
    }
    
    func goToBack() {
        programDetailProtocol?.didInvested()
        router.goToBack()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiInvest(with value: Double, completion: @escaping CompletionBlock) {
        ProgramDataProvider.investProgram(withAmount: value, investmentProgramId: investmentProgramId, completion: { (viewModel) in
            guard let walletsViewModel = viewModel, let wallets = walletsViewModel.wallets, let wallet = wallets.first else {
                return completion(.failure(reason: nil))
            }
            
            AuthManager.saveWalletViewModel(viewModel: wallet)
            completion(.success)
        }) { (result) in
            completion(result)
        }
    }
}
