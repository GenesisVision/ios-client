//
//  FundWithdrawViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//
import Foundation

final class FundWithdrawViewModel {
    
    // MARK: - Variables
    var title: String = "Withdraw"
    var fundId: String?
    var labelPlaceholder: String = "0"
    
    var fundWithdrawInfo: FundWithdrawInfo?
    
    private weak var detailProtocol: DetailProtocol?
    
    private var router: FundWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: FundWithdrawRouter,
         fundId: String,
         detailProtocol: DetailProtocol?) {
        self.router = router
        self.fundId = fundId
        self.detailProtocol = detailProtocol
    }
    
    // MARK: - Public methods
    func getInfo(completion: @escaping CompletionBlock) {
        guard let currency = InvestorAPI.Currency_v10InvestorFundsByIdWithdrawInfoByCurrencyGet(rawValue: getSelectedCurrency()), let fundId = fundId else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        FundsDataProvider.getWithdrawInfo(fundId: fundId, currencySecondary: currency, completion: { [weak self] (fundWithdrawInfo) in
            guard let fundWithdrawInfo = fundWithdrawInfo else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.fundWithdrawInfo = fundWithdrawInfo
            completion(.success)
            }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        apiWithdraw(with: amount, completion: completion)
    }
    
    func goToBack() {
        detailProtocol?.didWithdrawn()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiWithdraw(with amount: Double, completion: @escaping CompletionBlock) {
        FundsDataProvider.withdraw(withPercent: amount, fundId: fundId) { (result) in
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
