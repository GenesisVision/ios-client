//
//  ProfileViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProfileViewModel {
    
    // MARK: - Variables
    var title: String = "Profile"
    
    private var profileViewModel: ProfileFullViewModel?
    private var router: ProfileRouter!
    
    // MARK: - Init
    init(withRouter router: ProfileRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func signOut() {
        AuthManager.authorizedToken = nil
        router.show(routeType: .signOut)
    }
    
    func getProfile(completion: @escaping ApiCompletionBlock) {
        AuthManager.getProfile { [weak self] (viewModel) in
            self?.profileViewModel = viewModel
            completion(.success)
        }
    }
    
    
    // MARK: - Private methods
    
}
