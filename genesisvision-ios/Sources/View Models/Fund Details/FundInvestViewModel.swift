//
//  FundInvestViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class FundInvestViewModel {
    // MARK: - Variables
    var title: String = "Investment"
    var fundId: String?
    var labelPlaceholder: String = "0"
    
    var fundInvestInfo: FundInvestInfo?

    private weak var detailProtocol: DetailProtocol?
    
    private var router: FundInvestRouter!
    
    // MARK: - Init
    init(withRouter router: FundInvestRouter, fundId: String, detailProtocol: DetailProtocol?) {
        self.router = router
        self.fundId = fundId
        self.detailProtocol = detailProtocol
    }
    
    // MARK: - Public methods
    func getInfo(completion: @escaping CompletionBlock, completionError: @escaping CompletionBlock) {
        guard let currency = InvestorAPI.Currency_v10InvestorFundsByIdInvestInfoByCurrencyGet(rawValue: getSelectedCurrency()), let fundId = fundId else { return completionError(.failure(errorType: .apiError(message: nil))) }
        
        FundsDataProvider.getInvestInfo(fundId: fundId, currencySecondary: currency, completion: { [weak self] (fundInvestInfo) in
            guard let fundInvestInfo = fundInvestInfo else {
                return completionError(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.fundInvestInfo = fundInvestInfo
            completion(.success)
        }, errorCompletion: completionError)
    }
    
    // MARK: - Navigation
    func invest(with value: Double, completion: @escaping CompletionBlock) {
        apiInvest(with: value, completion: completion)
    }
    
    func goToBack() {
        detailProtocol?.didInvested()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
    
    // MARK: - Private methods
    // MARK: - API
    private func apiInvest(with value: Double, completion: @escaping CompletionBlock) {
        FundsDataProvider.invest(withAmount: value, fundId: fundId, errorCompletion: { (result) in
            completion(result)
        })
    }
}
