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
//    var dashboardTabmanViewController: DashboardTabmanViewController!
    var programsViewController: ProgramListViewController!
    
    var parentRouter: Router?
    var childRouters: [Router] = []
    
    //for authorized user
    weak var rootTabBarController: BaseTabBarController?
    
    weak var navigationController: UINavigationController?
    
    private var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        var navigationController = BaseNavigationController()
        
//        if isInvestorApp, let dashboardTabmanViewController = DashboardTabmanViewController.storyboardInstance(name: .dashboard) {
//            self.dashboardTabmanViewController = dashboardTabmanViewController
//            let router = DashboardRouter(parentRouter: self, navigationController: navigationController)
//            childRouters.append(router)
//            let viewModel = DashboardTabmanViewModel(withRouter: router)
//            dashboardTabmanViewController.viewModel = viewModel
//            dashboardTabmanViewController.tabBarItem.image = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_dashboard_unselected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_dashboard_unselected").withRenderingMode(.alwaysOriginal)
//            dashboardTabmanViewController.tabBarItem.selectedImage = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_dashboard_selected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_dashboard_selected").withRenderingMode(.alwaysOriginal)
//            dashboardTabmanViewController.tabBarItem.title = "DASHBOARD"
//            viewControllers.append(dashboardTabmanViewController)
//        }
        
        if isInvestorApp, let dashboardViewController = DashboardViewController.storyboardInstance(name: .dashboard) {
            self.dashboardViewController = dashboardViewController

            navigationController = BaseNavigationController(rootViewController: dashboardViewController)
            let router = DashboardRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
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
        
        if let walletViewController = WalletViewController.storyboardInstance(name: .wallet) {
            navigationController = BaseNavigationController(rootViewController: walletViewController)
            let router = WalletRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
            walletViewController.viewModel = WalletControllerViewModel(withRouter: router)
            navigationController.tabBarItem.image = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_wallet_unselected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_wallet_unselected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.selectedImage = AppearanceController.theme == .dark ? #imageLiteral(resourceName: "img_tabbar_wallet_selected").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_wallet_selected").withRenderingMode(.alwaysOriginal)
            navigationController.tabBarItem.title = "WALLET"
            viewControllers.append(navigationController)
        }
        
        if let profileViewController = ProfileViewController.storyboardInstance(name: .profile) {
            navigationController = BaseNavigationController(rootViewController: profileViewController)
            let router = ProfileRouter(parentRouter: self, navigationController: navigationController)
            childRouters.append(router)
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
//            self.dashboardTabmanViewController = parentRouter?.dashboardTabmanViewController
        }
        self.navigationController = navigationController != nil ? navigationController : parentRouter?.navigationController
        self.rootTabBarController = parentRouter?.rootTabBarController
    }
    
    // MARK: - Private methods
    private func createProgramsNavigationController() {
        guard let viewController = ProgramListViewController.storyboardInstance(name: .programs) else { return }
        self.programsViewController = viewController
        let router = InvestmentProgramListRouter(parentRouter: self)
        childRouters.append(router)
        programsViewController.viewModel = InvestmentProgramListViewModel(withRouter: router, reloadDataProtocol: programsViewController)
    }
    
    private func createTournamentNavigationController() {
        guard let viewController = TournamentListViewController.storyboardInstance(name: .tournament) else { return }
        tournamentViewController = viewController
        let router = TournamentRouter(parentRouter: self)
        childRouters.append(router)
        tournamentViewController.viewModel = TournamentListViewModel(withRouter: router, reloadDataProtocol: viewController, roundNumber: nil)
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
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
}
 
//Common methods
extension Router {
    func currentController() -> UIViewController? {
        return navigationController?.topViewController
    }
    
    func getProgramsVC() -> UIViewController? {
        guard let tabmanViewController = BaseTabmanViewController.storyboardInstance(name: .programs) else { return nil }
        let router = Router(parentRouter: self)
        tabmanViewController.viewModel = TabmanViewModel(withRouter: router)
        
        return tabmanViewController
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
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .program) else { return }
        viewController.delegate = vc as? ProgramDetailViewControllerProtocol
        
        let router = ProgramDetailRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailViewModel(withRouter: router, investmentProgramId: investmentProgramId, reloadDataProtocol: viewController, programPropertiesForTableViewCellViewProtocol: viewController, detailChartTableViewCellProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getDetailViewController(with investmentProgramId: String) -> ProgramDetailViewController? {
        guard let viewController = ProgramDetailViewController.storyboardInstance(name: .program) else { return nil }
        let router = ProgramDetailRouter(parentRouter: self)
        let viewModel = ProgramDetailViewModel(withRouter: router, investmentProgramId: investmentProgramId, reloadDataProtocol: viewController, programPropertiesForTableViewCellViewProtocol: viewController, detailChartTableViewCellProtocol: viewController)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
    
    func invest(with investmentProgramId: String, currency: String, availableToInvest: Double) {
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramInvestViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramInvestRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramInvestViewModel(withRouter: router, investmentProgramId: investmentProgramId, currency: currency, availableToInvest: availableToInvest, programDetailProtocol: vc as? ProgramDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with investmentProgramId: String, investedTokens: Double, currency: String) {
        guard let vc = currentController() else { return }
        
        guard let viewController = ProgramWithdrawViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramWithdrawRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, investmentProgramId: investmentProgramId, investedTokens: investedTokens, currency: currency, programDetailProtocol: vc as? ProgramDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToBack() {
        popViewController(animated: true)
    }
    
    func goToSecond() {
        popViewController(animated: false)
        popViewController(animated: true)
    }
    
    func goToRoot() {
        popToRootViewController(animated: true)
    }
    
    func closeVC() {
        dismiss(animated: true)
    }
}
