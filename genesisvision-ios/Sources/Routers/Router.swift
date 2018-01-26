//
//  Router.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIViewController

class Router {
    
    // MARK: - Variables
    fileprivate var parentRouter: Router?
    private var childRouter: Router?
    private var childRouters: [Router] = []
    
    weak var navigationController: UINavigationController?
    weak var tabBarController: UITabBarController?
    
    var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        if let controller = getTraiderListVC() {
            viewControllers.append(controller)
        }
        
        if isInvestorApp, let dashboardViewController = DashboardViewController.storyboardInstance(name: .dashboard) {
            dashboardViewController.viewModel = DashboardViewModel(withRouter: DashboardRouter())
            viewControllers.append(BaseNavigationController(rootViewController: dashboardViewController))
        }
        
        if let walletViewController = WalletViewController.storyboardInstance(name: .wallet) {
            walletViewController.viewModel = WalletViewModel(withRouter: WalletRouter())
            viewControllers.append(BaseNavigationController(rootViewController: walletViewController))
        }
        
        if let profileViewController = ProfileViewController.storyboardInstance(name: .profile) {
            profileViewController.viewModel = ProfileViewModel(withRouter: ProfileRouter())
            viewControllers.append(BaseNavigationController(rootViewController: profileViewController))
        }
        
        return viewControllers
    }
    
    var traderListViewController: TraderListViewController!
    
    // MARK: - Init
    init(parentRouter: Router?) {
        self.parentRouter = parentRouter
    }
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods
    
    func getTraiderListVC() -> UIViewController? {
        if traderListViewController != nil {
            return traderListViewController
        }
        
        guard let viewController = TraderListViewController.storyboardInstance(name: .traders) else { return nil }
        traderListViewController = viewController
        
        let navigationController = BaseNavigationController(rootViewController: traderListViewController)
        traderListViewController.viewModel = InvestmentProgramListViewModel(withRouter: InvestmentProgramListRouter(navigationController: navigationController))
        
        return navigationController
    }
    
    func startAsUnauthorized() {
        guard let controller = getTraiderListVC() else { return }
        setWindowRoot(viewController: controller)
    }
    
    func startAsAuthorized() {
        let tabBarController = BaseTabBarController()
        tabBarController.viewControllers = self.tabBarControllers
        
        self.tabBarController = tabBarController
        
        setWindowRoot(viewController: self.tabBarController)
    }
    
    func setWindowRoot(viewController: UIViewController?) {
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
}

extension Router {
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}
