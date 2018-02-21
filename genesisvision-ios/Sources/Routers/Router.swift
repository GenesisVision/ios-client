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
    func dismiss(animated: Bool)
}

class Router {
    
    // MARK: - Variables
    private var tournamentViewController: TournamentListViewController!
    private var programsViewController: ProgramListViewController!
    
    var parentRouter: Router?
    var childRouters: [Router] = []
    
    //for authorized user
    weak var rootTabBarController: UITabBarController?
    
    weak var navigationController: UINavigationController?
    
    private var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        if let navigationController = getProgramsNavigationController() {
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
        if isTournamentApp {
            self.tournamentViewController = parentRouter?.tournamentViewController
        } else {
            self.programsViewController = parentRouter?.programsViewController
        }
        self.navigationController = navigationController != nil ? navigationController : parentRouter?.navigationController
    }
    
    // MARK: - Private methods
    private func createProgramsNavigationController() {
        guard let viewController = ProgramListViewController.storyboardInstance(name: .traders) else { return }
        programsViewController = viewController
        let router = InvestmentProgramListRouter(parentRouter: self)
        childRouters.append(router)
        programsViewController.viewModel = InvestmentProgramListViewModel(withRouter: router)
    }
    
    private func createTournamentNavigationController() {
        guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return }
        tournamentViewController = viewController
        let router = TournamentRouter(parentRouter: self)
        childRouters.append(router)
        tournamentViewController.viewModel = TournamentListViewModel(withRouter: router)
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
    
    func dismiss(animated: Bool) {
        guard let viewController = navigationController?.topViewController else { return }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func setWindowRoot(viewController: UIViewController?) {
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
}
 
//Common methods
extension Router {
    func getProgramsNavigationController() -> UINavigationController? {
        createProgramsNavigationController()
        
        let navigationController = BaseNavigationController(rootViewController: programsViewController)
        programsViewController.viewModel.router.navigationController = navigationController
        
        return navigationController
    }
    
    func getTournamentNavigationController() -> UINavigationController? {
        createTournamentNavigationController()
        
        let navigationController = BaseNavigationController(rootViewController: tournamentViewController)
        tournamentViewController.viewModel.router.navigationController = navigationController
        
        return navigationController
    }
    
    func startAsUnauthorized() {
        guard let navigationController = getProgramsNavigationController() else { return }
        setWindowRoot(viewController: navigationController)
    }
    
    func startTournament() {
        guard let navigationController = getTournamentNavigationController() else { return }
        setWindowRoot(viewController: navigationController)
    }
    
    func startAsAuthorized() {
        let tabBarController = BaseTabBarController()
        tabBarController.viewControllers = tabBarControllers
        
        rootTabBarController = tabBarController
        
        setWindowRoot(viewController: rootTabBarController)
    }
}
