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
    
    var isFavorite: Bool {
        return programDetailsFull?.personalProgramDetails?.isFavorite ?? false
    }
    
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
        ProgramsDataProvider.get(programId: programId, currencySecondary: сurrency, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.programDetailsFull = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
    
    // MARK: - Public methods
    func changeFavorite(completion: @escaping CompletionBlock) {
        guard
            let personalProgramDetails = programDetailsFull?.personalProgramDetails,
            let isFavorite = personalProgramDetails.isFavorite,
            let programId = programId
            else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsDataProvider.favorites(isFavorite: isFavorite, assetId: programId) { [weak self] (result) in
            switch result {
            case .success:
                self?.programDetailsFull?.personalProgramDetails?.isFavorite = !isFavorite
            case .failure(let errorType):
                print(errorType)
                self?.programDetailsFull?.personalProgramDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
    }
    
    func setScrollEnable(_ value: Bool) {
//        if let viewModel = router.programDetailsTabmanViewController?.viewModel {
//            for controller in viewModel.viewControllers {
//                if let vc = controller as? BaseViewControllerWithTableView {
//                    vc.tableView?.isScrollEnabled = value
//                }
//            }
//        }
    }
    
}
