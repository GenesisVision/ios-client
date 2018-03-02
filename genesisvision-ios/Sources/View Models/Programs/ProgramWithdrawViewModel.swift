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
    private weak var programDetailProtocol: ProgramDetailProtocol?
    
    private var router: ProgramWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramWithdrawRouter, investmentProgramId: String, programDetailProtocol: ProgramDetailProtocol?) {
        self.router = router
        self.investmentProgramId = investmentProgramId
        self.programDetailProtocol = programDetailProtocol
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, completion: completion)
    }
    
    func withdrawAll(completion: @escaping CompletionBlock) {
        //TODO: add to API method
        apiWithdrawAll(completion: completion)
    }
    
    func goBack() {
        programDetailProtocol?.didWithdrawn()
        router.goBack()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, completion: @escaping CompletionBlock) {
        guard let programId = investmentProgramId,
            let uuid = UUID(uuidString: programId),
            let token = AuthManager.authorizedToken
            else { return completion(.failure(reason: nil)) }
        
        let investModel = Invest(investmentProgramId: uuid, amount: amount)
        
        InvestorAPI.apiInvestorInvestmentProgramsWithdrawPost(authorization: token, model: investModel) { [weak self] (error) in
            self?.responseHandler(error, completion: completion)
        }
    }
    
    private func apiWithdrawAll(completion: @escaping CompletionBlock) {
        guard let programId = investmentProgramId,
            let uuid = UUID(uuidString: programId),
            let token = AuthManager.authorizedToken
            else { return completion(.failure(reason: nil)) }

//        let investModel = Invest(investmentProgramId: uuid)
        
//        InvestorAPI.apiInvestorInvestmentsWithdrawPost(authorization: token, model: investModel) { [weak self] (error) in
//            self?.responseHandler(error, completion: completion)
//        }
    }
    
    private func responseHandler(_ error: Error?, completion: @escaping CompletionBlock) {
        if let error = error {
            return ErrorHandler.handleApiError(error: error, completion: completion)
        }
        
        completion(.success)
    }
}
