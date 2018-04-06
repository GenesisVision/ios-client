//
//  ProgramWithdrawViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//
import Foundation

final class ProgramWithdrawViewModel {
    
    // MARK: - Variables
    var title: String = "Withdraw"
    var investmentProgramId: String?
    var investedTokens: Double?
    
    private var rate: Double = 0.0
    private var balance: Double = 0.0 {
        didSet {
            self.exchangedBalance = balance * self.rate
        }
    }
    
    private var exchangedBalance: Double = 0.0
    var currency: String = "GVT"
    
    private weak var programDetailProtocol: ProgramDetailProtocol?
    
    private var router: ProgramWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramWithdrawRouter,
         investmentProgramId: String,
         investedTokens: Double,
         currency: String,
         programDetailProtocol: ProgramDetailProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.investedTokens = investedTokens
        self.currency = currency
        self.programDetailProtocol = programDetailProtocol
    }
    
    // MARK: - Public methods
    
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, completion: completion)
    }
    
    func showWithdrawRequestedVC() {
        router.show(routeType: .withdrawRequested)
    }
    
    func goToBack() {
        programDetailProtocol?.didWithdrawn()
        router.goToBack()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, completion: @escaping CompletionBlock) {
        ProgramDataProvider.withdrawProgram(withAmount: amount, investmentProgramId: investmentProgramId) { (result) in
            completion(result)
        }
    }
    
    private func responseHandler(_ error: Error?, completion: @escaping CompletionBlock) {
        if let error = error {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        completion(.success)
    }
}
