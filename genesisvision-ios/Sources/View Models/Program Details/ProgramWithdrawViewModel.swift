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
    var programId: String?
    var labelPlaceholder: String = "0"
    
    var programWithdrawInfo: ProgramWithdrawInfo?
    
    private weak var programDetailProtocol: ProgramDetailProtocol?
    
    private var router: ProgramWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramWithdrawRouter,
         programId: String,
         programDetailProtocol: ProgramDetailProtocol?) {
        self.router = router
        self.programId = programId
        self.programDetailProtocol = programDetailProtocol
    }
    
    // MARK: - Public methods
    func getInfo(completion: @escaping CompletionBlock) {
        guard let currency = InvestorAPI.Currency_v10InvestorProgramsByIdWithdrawInfoByCurrencyGet(rawValue: getSelectedCurrency()), let programId = programId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsDataProvider.getProgramWithdrawInfo(programId: programId, currencySecondary: currency, completion: { [weak self] (programWithdrawInfo) in
            guard let programWithdrawInfo = programWithdrawInfo else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.programWithdrawInfo = programWithdrawInfo
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, completion: completion)
    }
    
    func showWithdrawRequestedVC() {
        programDetailProtocol?.didWithdrawn()
        router.show(routeType: .withdrawRequested)
    }
    
    func goToBack() {
        programDetailProtocol?.didWithdrawn()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, completion: @escaping CompletionBlock) {
        ProgramsDataProvider.withdrawProgram(withAmount: amount, programId: programId) { (result) in
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
