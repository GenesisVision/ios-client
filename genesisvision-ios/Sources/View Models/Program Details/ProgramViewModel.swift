//
//  ProgramViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ProgramViewModel {
    // MARK: - Variables
    var programId: String!
    var programDetailsFull: ProgramDetailsFull?
    
    var router: ProgramRouter!
    
    // MARK: - Init
    init(withRouter router: Router, programId: String, programViewController: ProgramViewController) {
        self.programId = programId
        
        self.router = ProgramRouter(parentRouter: router, navigationController: nil, programViewController: programViewController)
    }
    
    func showNotifications() {
        router.show(routeType: .notifications)
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        let сurrency = ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet(rawValue: getSelectedCurrency())
        ProgramsDataProvider.getProgram(programId: programId, currencySecondary: сurrency, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.programDetailsFull = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
}
