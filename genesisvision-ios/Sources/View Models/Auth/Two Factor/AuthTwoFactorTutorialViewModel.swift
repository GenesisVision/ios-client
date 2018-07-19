//
//  AuthTwoFactorTutorialViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class AuthTwoFactorTutorialViewModel {
    // MARK: - Variables
    var title: String = "How to".uppercased()
    var numberOfPages = 5
    
    private var tabmanViewModel: AuthTwoFactorTabmanViewModel!
    private var router: TabmanRouter!
    
    // MARK: - Init
    init(withRouter router: TabmanRouter, tabmanViewModel: AuthTwoFactorTabmanViewModel) {
        self.router = router
        self.tabmanViewModel = tabmanViewModel
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func nextStep() {
        router.next()
    }
}
