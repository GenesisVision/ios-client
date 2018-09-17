//
//  AssetsPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy

class AssetsPageboyViewControllerDataSource: NSObject, PageboyViewControllerDataSource {
    var controllers: [BaseViewController]!
    
    init(vc: AssetsViewController) {
        super.init()
        
        if let programListViewController = ProgramListViewController.storyboardInstance(name: .programs),
            let favoriteListViewController = ProgramListViewController.storyboardInstance(name: .programs) {
            
            let programsRouter = InvestmentProgramListRouter(parentRouter: nil, navigationController: BaseNavigationController(rootViewController: programListViewController))
            let programsViewModel = InvestmentProgramListViewModel(withRouter: programsRouter, reloadDataProtocol: programListViewController)
            programListViewController.viewModel = programsViewModel
            
            let favoriteRouter = FavoriteProgramListRouter(parentRouter: nil, navigationController: BaseNavigationController(rootViewController: favoriteListViewController), favoriteProgramListViewController: favoriteListViewController)
            let favoriteViewModel = FavoriteProgramListViewModel(withRouter: favoriteRouter, reloadDataProtocol: favoriteListViewController)
            favoriteListViewController.viewModel = favoriteViewModel
            
            controllers = [programListViewController, favoriteListViewController]
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return controllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return controllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }
}
