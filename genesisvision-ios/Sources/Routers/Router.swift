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

enum TabsType: Int {
    case dashboard, programList, wallet, profile
}

class Router {
    // MARK: - Variables
    private var tournamentViewController: TournamentListViewController!
    private var programsViewController: ProgramListViewController!
    
    var parentRouter: Router?
    var childRouters: [Router] = []
    
    //for authorized user
    weak var rootTabBarController: BaseTabBarController?
    
    weak var navigationController: UINavigationController?
    
    private var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        var navigationController = BaseNavigationController()
        
        if isInvestorApp, let dashboardViewController = DashboardViewController.storyboardInstance(name: .dashboard) {
            navigationController = BaseNavigationController(rootViewController: dashboardViewController)
            let router = DashboardRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            dashboardViewController.viewModel = DashboardViewModel(withRouter: router)
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_tabbar_dashboard_unselected")
            navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "img_tabbar_dashboard_selected")
            navigationController.tabBarItem.title = "DASHBOARD"
            viewControllers.append(navigationController)
        }
        
        if let navigationController = getProgramsNavigationController() {
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_tabbar_program_list_unselected")
            navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "img_tabbar_program_list_selected")
            navigationController.tabBarItem.title = "PROGRAMS"
            viewControllers.append(navigationController)
        }
        
        if let walletViewController = WalletViewController.storyboardInstance(name: .wallet) {
            navigationController = BaseNavigationController(rootViewController: walletViewController)
            let router = WalletRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            walletViewController.viewModel = WalletControllerViewModel(withRouter: router)
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_tabbar_wallet_unselected")
            navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "img_tabbar_wallet_selected")
            navigationController.tabBarItem.title = "WALLET"
            viewControllers.append(navigationController)
        }
        
        if let profileViewController = ProfileViewController.storyboardInstance(name: .profile) {
            navigationController = BaseNavigationController(rootViewController: profileViewController)
            let router = ProfileRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            profileViewController.viewModel = ProfileViewModel(withRouter: router, textFieldDelegate: profileViewController)
            navigationController.tabBarItem.image = #imageLiteral(resourceName: "img_tabbar_profile_unselected")
            navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "img_tabbar_profile_selected")
            navigationController.tabBarItem.title = "PROFILE"
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
        self.rootTabBarController = parentRouter?.rootTabBarController
    }
    
    // MARK: - Private methods
    private func createProgramsNavigationController() {
        guard let viewController = ProgramListViewController.storyboardInstance(name: .traders) else { return }
        programsViewController = viewController
        let router = InvestmentProgramListRouter(parentRouter: self)
        childRouters.append(router)
        programsViewController.viewModel = InvestmentProgramListViewModel(withRouter: router, reloadDataProtocol: viewController)
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
    func currentController() -> UIViewController? {
        return navigationController?.topViewController
    }
    
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
    
    func getRootTabBar(parent: Router?) -> UITabBarController? {
        if let rootTabBarController = parent?.rootTabBarController {
            return rootTabBarController
        }
        
        if let parent = parent {
            return getRootTabBar(parent: parent.parentRouter)
        }
        
        return nil
    }
    
    func changeTab(withParentRouter parent: Router?, to tabType: TabsType) {
        getRootTabBar(parent: parent)?.selectedIndex = tabType.rawValue
    }
    
    func showProgramDetail(with investmentProgramId: String) {
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramDetailRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailViewModel(withRouter: router, with: investmentProgramId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getDetailViewController(with investmentProgramId: String) -> ProgramDetailViewController? {
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .traders) else { return nil }
        let router = ProgramDetailRouter(parentRouter: self)
        let viewModel = ProgramDetailViewModel(withRouter: router, with: investmentProgramId, reloadDataProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
    
    func invest(with investmentProgramId: String, currency: String) {
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramInvestViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramInvestRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramInvestViewModel(withRouter: router, investmentProgramId: investmentProgramId, currency: currency, programDetailProtocol: vc as? ProgramDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with investmentProgramId: String, investedTokens: Double, currency: String) {
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramWithdrawViewController.storyboardInstance(name: .traders) else { return }
        let router = ProgramWithdrawRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, investmentProgramId: investmentProgramId, investedTokens: investedTokens, currency: currency, programDetailProtocol: vc as? ProgramDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToBack() {
        popViewController(animated: true)
    }
    
    func closeVC() {
        dismiss(animated: true)
    }
}
