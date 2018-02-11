//
//  Router.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIViewController

protocol RouterProtocol {
    func popToRootViewController(animated: Bool)
    func popToViewController(viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    func push(viewController: UIViewController)
    //Modal
    func present(viewController: UIViewController, from currentViewController: UIViewController)
}

class Router {
    
    // MARK: - Variables
    private var traidersViewController: TraderListViewController!
    
    var parentRouter: Router?
    var childRouters: [Router] = []
    
    //for authorized user
    weak var rootTabBarController: UITabBarController?
    
    weak var navigationController: UINavigationController?
    
    private var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        if let navigationController = getTraidersNavigationController() {
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_program_list")
            navigationController.tabBarItem.title = "Invest"
            viewControllers.append(navigationController)
        }
        
        var navigationController = BaseNavigationController()
        
        if isInvestorApp, let dashboardViewController = DashboardViewController.storyboardInstance(name: .dashboard) {
            navigationController = BaseNavigationController(rootViewController: dashboardViewController)
            let router = DashboardRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            dashboardViewController.viewModel = DashboardViewModel(withRouter: router)
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_dashboard")
            navigationController.tabBarItem.title = "Dashboard"
            viewControllers.append(navigationController)
        }
        
        if let walletViewController = WalletViewController.storyboardInstance(name: .wallet) {
            navigationController = BaseNavigationController(rootViewController: walletViewController)
            let router = WalletRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            walletViewController.viewModel = WalletViewModel(withRouter: router)
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_wallet")
            navigationController.tabBarItem.title = "Wallet"
            viewControllers.append(navigationController)
        }
        
        if let profileViewController = ProfileViewController.storyboardInstance(name: .profile) {
            navigationController = BaseNavigationController(rootViewController: profileViewController)
            let router = ProfileRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            profileViewController.viewModel = ProfileViewModel(withRouter: router)
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_profile")
            navigationController.tabBarItem.title = "Profile"
            viewControllers.append(navigationController)
        }
        
        return viewControllers
    }
    
    // MARK: - Init
    init(parentRouter: Router?, navigationController: UINavigationController? = nil) {
        self.parentRouter = parentRouter
        self.traidersViewController = parentRouter?.traidersViewController
        self.navigationController = navigationController != nil ? navigationController : parentRouter?.navigationController
    }
    
    // MARK: - Private methods
    private func createTraidersNavigationController() {
        guard let viewController = TraderListViewController.storyboardInstance(name: .traders) else { return }
        traidersViewController = viewController
        let router = InvestmentProgramListRouter(parentRouter: self)
        childRouters.append(router)
        traidersViewController.viewModel = InvestmentProgramListViewModel(withRouter: router)
    }
}

//Protocol methods
extension Router: RouterProtocol {
    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool) {
        navigationController?.popToViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func push(viewController: UIViewController) {
        navigationController?.push(viewController: viewController)
    }
    
    //Modal
    func present(viewController: UIViewController, from currentViewController: UIViewController) {
        currentViewController.present(viewController: viewController)
    }
    
    func setWindowRoot(viewController: UIViewController?) {
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
}
 
//Common methods
extension Router {
    func getTraidersNavigationController() -> UINavigationController? {
        createTraidersNavigationController()
        
        let navigationController = BaseNavigationController(rootViewController: traidersViewController)
        traidersViewController.viewModel.router.navigationController = navigationController
        
        return navigationController
    }
    
    func startAsUnauthorized() {
        guard let navigationController = getTraidersNavigationController() else { return }
        setWindowRoot(viewController: navigationController)
    }
    
    func startTournament() {
        startAsUnauthorized()
    }
    
    func startAsAuthorized() {
        let tabBarController = BaseTabBarController()
        tabBarController.viewControllers = tabBarControllers
        
        rootTabBarController = tabBarController
        
        setWindowRoot(viewController: rootTabBarController)
    }
}
