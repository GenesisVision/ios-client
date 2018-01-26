//
//  WelcomeViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {

    var viewModel: WelcomeViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationController = BaseNavigationController()
        let router = WelcomeRouter(navigationController: navigationController)
        viewModel = WelcomeViewModel(withRouter: router)
        viewModel.start()
    }
}
