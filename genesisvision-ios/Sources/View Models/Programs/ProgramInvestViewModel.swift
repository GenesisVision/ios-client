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
            completion(String(describing: "Balance: \(value) GVT"))
        })
    }
    
    // MARK: - Navigation
    func invest(with value: Double, completion: @escaping CompletionBlock) {
        apiInvest(with: value, completion: completion)
    }
    
    func goBack() {
        programDetailProtocol?.didInvested()
        router.goBack()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiInvest(with value: Double, completion: @escaping CompletionBlock) {
        guard let programId = investmentProgramId,
            let uuid = UUID(uuidString: programId),
            let token = AuthManager.authorizedToken
            else { return completion(.failure(reason: nil)) }
        
        let investModel = Invest(investmentProgramId: uuid, amount: value)
        InvestorAPI.apiInvestorInvestmentProgramsInvestPost(authorization: token, model: investModel) { [weak self] (walletViewModel, error) in
            self?.responseHandler(walletViewModel, error: error, completion: completion)
        }
    }
    
    private func responseHandler(_ viewModel: WalletsViewModel?, error: Error?, completion: @escaping CompletionBlock) {
        guard let walletsViewModel = viewModel, let wallets = walletsViewModel.wallets, let wallet = wallets.first else {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }

        AuthManager.saveWalletViewModel(viewModel: wallet)

        completion(.success)
    }
}
