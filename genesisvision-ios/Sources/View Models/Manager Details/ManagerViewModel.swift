//
//  ManagerViewModel.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ManagerViewModel {
    // MARK: - Variables
    var managerId: String!
    var managerProfileDetails: ManagerProfileDetails?
    
    var router: ManagerRouter!
    
    // MARK: - Init
    init(withRouter router: Router, managerId: String, managerViewController: ManagerViewController) {
        self.managerId = managerId
        
        self.router = ManagerRouter(parentRouter: router, navigationController: nil, managerViewController: managerViewController)
    }

    func fetch(completion: @escaping CompletionBlock) {
        ManagersDataProvider.getManagerProfileDetails(managerId: managerId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.managerProfileDetails = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
}

