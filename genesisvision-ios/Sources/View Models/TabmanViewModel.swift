//
//  TabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

final class TabmanViewModel {
    // MARK: - Variables
    var title: String = "Tournament"
    
    var router: Router!
    var viewControllers = [UIViewController]()
    var itemTitles = [String]()
    weak var pageboyViewControllerDataSource: PageboyViewControllerDataSource?
    
    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
        
        initializeViewControllers()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    private func initializeViewControllers() {
        for idx in 1...4 {
            guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return }
            let router = TournamentRouter(parentRouter: self.router)
            let viewModel = TournamentListViewModel(withRouter: router, roundNumber: idx)
            viewController.viewModel = viewModel
            itemTitles.append("Round \(idx)")
            viewControllers.append(viewController)
        }
    }
}
