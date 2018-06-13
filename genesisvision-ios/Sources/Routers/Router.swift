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
    func present(viewController: UIViewController)
    func present(viewController: UIViewController, from currentViewController: UIViewController)
    func dismiss(animated: Bool)
}

enum TabsType: Int {
    case dashboard, programList, wallet, profile
}

class Router {
    // MARK: - Variables
    var tournamentViewController: TournamentListViewController!
    var dashboardViewController: DashboardViewController!
    var programsViewController: ProgramListViewController!
    
    var currentController: UIViewController?
    
    var parentRouter: Router?
    
    //for authorized user
    weak var rootTabBarController: BaseTabBarController?
    
    weak var navigationController: UINavigationController?
    
    private var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        var navigationController = BaseNavigationController()
        
        if isInvestorApp {
            let dashboardViewController = DashboardViewController()
            self.dashboardViewController = dashboardViewController

            navigationController = BaseNavigationController(rootViewController: dashboardViewController)
            let router = DashboardRouter(parentRouter: self, navigationController: navigationController)
            dashboardViewController.viewModel = DashboardViewModel(withRouter: router)
            navigationController.tabBarItem.image = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_dashboard_unselected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_dashboard_unselected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.selectedImage = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_dashboard_selected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_dashboard_selected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.title = "DASHBOARD"
            viewControllers.append(navigationController)
        }
        
        if let navigationController = getProgramsNavigationController() {
            navigationController.tabBarItem.image = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_program_list_unselected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_program_list_unselected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.selectedImage = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_program_list_selected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_program_list_selected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.title = "PROGRAMS"
            viewControllers.append(navigationController)
        }
        
        let walletViewController = WalletViewController()
        navigationController = BaseNavigationController(rootViewController: walletViewController)
        let router = WalletRouter(parentRouter: self, navigationController: navigationController)
        walletViewController.viewModel = WalletControllerViewModel(withRouter: router)
        navigationController.tabBarItem.image = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_wallet_unselected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_wallet_unselected").withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_wallet_selected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_wallet_selected").withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.title = "WALLET"
        viewControllers.append(navigationController)
        
        if let profileViewController = ProfileViewController.storyboardInstance(name: .profile) {
            navigationController = BaseNavigationController(rootViewController: profileViewController)
            let router = ProfileRouter(parentRouter: self, navigationController: navigationController)
            profileViewController.viewModel = ProfileViewModel(withRouter: router, textFieldDelegate: profileViewController)
            navigationController.tabBarItem.image = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_profile_unselected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_profile_unselected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.selectedImage = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_profile_selected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_profile_selected").withRenderingMode(.alwaysOriginal)
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
            self.dashboardViewController = parentRouter?.dashboardViewController
        }
        
        self.navigationController = navigationController != nil ? navigationController : parentRouter?.navigationController
        self.rootTabBarController = parentRouter?.rootTabBarController
        
        self.currentController = topViewController()
    }
    
    // MARK: - Private methods
    private func getProgramsNavigationController() -> UINavigationController? {
        guard let viewController = ProgramListViewController.storyboardInstance(name: .programs) else { return nil }
        self.programsViewController = viewController
        
        let navigationController = BaseNavigationController(rootViewController: programsViewController)
        let router = InvestmentProgramListRouter(parentRouter: self, navigationController: navigationController)
        programsViewController.viewModel = InvestmentProgramListViewModel(withRouter: router, reloadDataProtocol: programsViewController)
        
        return navigationController
    }
    
    private func getTournamentNavigationController() -> UINavigationController? {
        guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return nil }
        tournamentViewController = viewController
        
        let navigationController = BaseNavigationController(rootViewController: tournamentViewController)
        let router = TournamentListRouter(parentRouter: self, navigationController: navigationController)
        tournamentViewController.viewModel = TournamentListViewModel(withRouter: router, reloadDataProtocol: viewController, roundNumber: nil)
        
        return navigationController
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
    func present(viewController: UIViewController) {
        navigationController?.present(viewController: viewController)
    }
    
    func present(viewController: UIViewController, from currentViewController: UIViewController) {
        currentViewController.present(viewController: viewController)
    }
    
    func dismiss(animated: Bool) {
        guard let viewController = navigationController?.topViewController else { return }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func setWindowRoot(viewController: UIViewController?) {
        guard viewController != nil else { return }
        
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
}
 
//Common methods
extension Router {
    func topViewController() -> UIViewController? {
        return navigationController?.topViewController
    }
   
    func startAsForceSignOut() {
        guard let navigationController = getProgramsNavigationController(),
            let programsVC = navigationController.topViewController as? ProgramListViewController,
            let viewModel = programsVC.viewModel,
            let router = viewModel.router else { return }
        
        router.show(routeType: .signIn)
        
        setWindowRoot(viewController: navigationController)
    }
    
    func startTournament() {
        guard let navigationController = getTournamentNavigationController() else { return }
        setWindowRoot(viewController: navigationController)
    }
    
    func startAsUnauthorized() {
        guard let navigationController = getProgramsNavigationController() else { return }
        setWindowRoot(viewController: navigationController)
    }
    
    func startAsAuthorized() {
        let tabBarController = BaseTabBarController()
        tabBarController.viewControllers = tabBarControllers
    
        rootTabBarController = tabBarController
        
        setWindowRoot(viewController: rootTabBarController)
    }
    
    func showTwoFactorEnable() {
        guard let viewController = getTwoFactorEnableViewController() else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
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
    
    func showProgramDetails(with investmentProgramId: String) {
        guard let viewController = getDetailsViewController(with: investmentProgramId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getDetailsViewController(with investmentProgramId: String) -> ProgramDetailsTabmanViewController? {
        guard let vc = currentController else { return nil }
        
        let tabmanViewController = ProgramDetailsTabmanViewController()
        tabmanViewController.programDetailViewControllerProtocol = vc as? ProgramDetailViewControllerProtocol
        
        let router = ProgramDetailsRouter(parentRouter: self, tabmanViewController: tabmanViewController)
        router.currentController = tabmanViewController
        let viewModel = ProgramDetailsViewModel(withRouter: router, investmentProgramId: investmentProgramId, tabmanViewModelDelegate: tabmanViewController)
        viewModel.programDetailsProtocol = tabmanViewController
        tabmanViewController.viewModel = viewModel
        tabmanViewController.hidesBottomBarWhenPushed = true
        
        return tabmanViewController
    }
    
    func getTwoFactorEnableViewController() -> AuthTwoFactorTabmanViewController? {
        let tabmanViewController = AuthTwoFactorTabmanViewController()
        let router = AuthTwoFactorTabmanRouter(parentRouter: self, tabmanViewController: tabmanViewController)
        tabmanViewController.viewModel = AuthTwoFactorTabmanViewModel(withRouter: router, tabmanViewModelDelegate: tabmanViewController)
        tabmanViewController.hidesBottomBarWhenPushed = true
        
        return tabmanViewController
    }
    
    func getTwoFactorDisableViewController() -> AuthTwoFactorConfirmationViewController? {
        guard let viewController = AuthTwoFactorConfirmationViewController.storyboardInstance(name: .auth) else { return nil }
        let router = AuthTwoFactorDisableRouter(parentRouter: self)
        viewController.viewModel = AuthTwoFactorDisableConfirmationViewModel(withRouter: router)
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
    
    func goToBack(animated: Bool = false) {
        popViewController(animated: animated)
    }
    
    func goToSecond() {
        popViewController(animated: false)
        popViewController(animated: false)
    }
    
    func goToRoot(animated: Bool = true) {
        popToRootViewController(animated: animated)
    }
    
    func closeVC(animated: Bool = true) {
        dismiss(animated: animated)
    }
}
