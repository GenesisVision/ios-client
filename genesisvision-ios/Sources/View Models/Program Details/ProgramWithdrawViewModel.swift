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
    var assetId: String
    var programCurrency: CurrencyType
    var labelPlaceholder: String = "0"
    
    var withdrawAll: Bool = false
    
    var programWithdrawInfo: ProgramWithdrawInfo?
    
    var programDetails: ProgramFollowDetailsFull?
    
    private weak var detailProtocol: ReloadDataProtocol?
    
    private var router: ProgramWithdrawRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramWithdrawRouter,
         assetId: String,
         programCurrency: CurrencyType,
         detailProtocol: ReloadDataProtocol?) {
        self.router = router
        self.assetId = assetId
        self.programCurrency = programCurrency
        self.detailProtocol = detailProtocol
    }
    
    // MARK: - Public methods
    func getInfo(completion: @escaping CompletionBlock) {
        ProgramsDataProvider.getWithdrawInfo(assetId, completion: { [weak self] (programWithdrawInfo) in
            guard let programWithdrawInfo = programWithdrawInfo else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            self?.getProgramsDetails(completion: completion)
            self?.programWithdrawInfo = programWithdrawInfo
            }, errorCompletion: completion)
    }
    
    func getProgramsDetails(completion: @escaping CompletionBlock) {
        ProgramsDataProvider.get(assetId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            self?.programDetails = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Navigation
    func withdraw(with amount: Double, completion: @escaping CompletionBlock) {
        ProgramsDataProvider.withdraw(withAmount: withdrawAll ? nil : amount, assetId: assetId, withdrawAll: withdrawAll) { (result) in
            completion(result)
        }
    }
    
    func goToBack() {
        detailProtocol?.didReloadData()
        router.goToBack()
    }
    
    func close() {
        router.closeVC()
    }
}
