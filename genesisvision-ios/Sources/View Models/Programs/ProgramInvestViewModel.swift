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
    var title: String = "Invest"
    var investmentProgramId: String?
    private weak var programDetailProtocol: ProgramDetailProtocol?
    
    private var router: ProgramInvestRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInvestRouter, investmentProgramId: String, programDetailProtocol: ProgramDetailProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.programDetailProtocol = programDetailProtocol
    }
    
    // MARK: - Public methods
    func getAmountText(completion: @escaping (_ text: String) -> Void) {
        AuthManager.getBalance(completion: { (value) in
            let valueText = value.toString()
            let text = "Balance: " + valueText + " GVT"
            completion(text)
        })
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
