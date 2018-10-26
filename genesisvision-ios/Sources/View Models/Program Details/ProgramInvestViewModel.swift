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
    var programId: String?
    var labelPlaceholder: String = "0"
    
    var programInvestInfo: ProgramInvestInfo?

    private weak var detailProtocol: DetailProtocol?
    
    private var router: ProgramInvestRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramInvestRouter, programId: String, detailProtocol: DetailProtocol?) {
        self.router = router
        self.programId = programId
        self.detailProtocol = detailProtocol
    }
    
    // MARK: - Public methods
    func getInfo(completion: @escaping CompletionBlock, completionError: @escaping CompletionBlock) {
        guard let currency = InvestorAPI.Currency_v10InvestorProgramsByIdInvestInfoByCurrencyGet(rawValue: getSelectedCurrency()), let programId = programId else { return completionError(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsDataProvider.getInvestInfo(programId: programId, currencySecondary: currency, completion: { [weak self] (programInvestInfo) in
            guard let programInvestInfo = programInvestInfo else {
                return completionError(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.programInvestInfo = programInvestInfo
            completion(.success)
        }, errorCompletion: completionError)
    }
    
    // MARK: - Navigation
    func invest(with value: Double, completion: @escaping CompletionBlock) {
        apiInvest(with: value, completion: completion)
    }
    
    func showInvestmentRequestedVC(investedAmount: Double) {
        detailProtocol?.didInvested()
        router.show(routeType: .investmentRequested(investedAmount: investedAmount))
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
        ProgramsDataProvider.invest(withAmount: value, programId: programId, errorCompletion: { (result) in
            completion(result)
        })
    }
}
