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
    var investorDashboardViewController: InvestorDashboardViewController!
    var managerDashboardViewController: ManagerDashboardViewController!
    var programsViewController: ProgramListViewController!
    var fundsViewController: FundListViewController!

    var assetsViewController: AssetsViewController!
    
    var currentController: UIViewController?
    
    var parentRouter: Router?
    
    //for authorized user
    weak var rootTabBarController: BaseTabBarController?
    
    weak var navigationController: UINavigationController?
    
    var tabBarControllers: [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        var navigationController = BaseNavigationController()
        
        addDashboard(&navigationController, &viewControllers)
        addPrograms(&viewControllers)
        addWallet(&navigationController, &viewControllers)
        addSettings(&navigationController, &viewControllers)
        
        return viewControllers
    }
    
    // MARK: - Init
    init(parentRouter: Router?, navigationController: UINavigationController? = nil) {
        self.parentRouter = parentRouter

        self.programsViewController = parentRouter?.programsViewController
        self.fundsViewController = parentRouter?.fundsViewController
        self.assetsViewController = parentRouter?.assetsViewController
        self.investorDashboardViewController = parentRouter?.investorDashboardViewController
        self.managerDashboardViewController = parentRouter?.managerDashboardViewController
        
        self.navigationController = navigationController != nil ? navigationController : parentRouter?.navigationController
        self.rootTabBarController = parentRouter?.rootTabBarController
        
        self.currentController = topViewController()
    }
    
    // MARK: - Private methods
    private func getAssetsNavigationController() -> BaseNavigationController? {
        let assetsVC = AssetsViewController()
        self.assetsViewController = assetsVC
        
        let navigationController = BaseNavigationController(rootViewController: assetsViewController)
        let router = Router(parentRouter: self, navigationController: navigationController)
        let viewModel = AssetsTabmanViewModel(withRouter: router)
        assetsViewController.viewModel = viewModel
        
        return navigationController
    }
    
    private func addDashboard(_ navigationController: inout BaseNavigationController, _ viewControllers: inout [UIViewController]) {
        
        if isInvestorApp, let viewController = InvestorDashboardViewController.storyboardInstance(name: .dashboard) {
            self.investorDashboardViewController = viewController
            
            navigationController = BaseNavigationController(rootViewController: viewController)
            let router = DashboardRouter(parentRouter: self, navigationController: navigationController, dashboardViewController: viewController)
            viewController.viewModel = DashboardViewModel(withRouter: router)
        } else {
            let viewController = ManagerDashboardViewController()
            self.managerDashboardViewController = viewController
            
            navigationController = BaseNavigationController(rootViewController: viewController)
            let router = DashboardRouter(parentRouter: self, navigationController: navigationController, dashboardViewController: viewController)
            viewController.viewModel = DashboardViewModel(withRouter: router)
        }
        
        
        navigationController.tabBarItem.image = AppearanceController.theme == .darkTheme ? #imageLiteral(resourceName: "img_tabbar_dashboard").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_dashboard").withRenderingMode(.alwaysOriginal)
        viewControllers.append(navigationController)
    }
    
    private func addPrograms(_ viewControllers: inout [UIViewController]) {
        if let navigationController = getAssetsNavigationController() {
            navigationController.tabBarItem.image = AppearanceController.theme == .darkTheme ? #imageLiteral(resourceName: "img_tabbar_program_list").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_program_list").withRenderingMode(.alwaysOriginal)
            viewControllers.append(navigationController)
        }
    }
    
    private func addWallet(_ navigationController: inout BaseNavigationController, _ viewControllers: inout [UIViewController]) {
        guard let walletViewController = WalletViewController.storyboardInstance(name: .wallet) else { return }
        navigationController = BaseNavigationController(rootViewController: walletViewController)
        let router = WalletRouter(parentRouter: self, navigationController: navigationController)
        walletViewController.viewModel = WalletControllerViewModel(withRouter: router)
        navigationController.tabBarItem.image = AppearanceController.theme == .darkTheme ? #imageLiteral(resourceName: "img_tabbar_wallet").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_wallet").withRenderingMode(.alwaysOriginal)
        viewControllers.append(navigationController)
    }
    
    private func addSettings(_ navigationController: inout BaseNavigationController, _ viewControllers: inout [UIViewController]) {
        if let settingsViewController = SettingsViewController.storyboardInstance(name: .settings) {
            navigationController = BaseNavigationController(rootViewController: settingsViewController)
            let router = SettingsRouter(parentRouter: self, navigationController: navigationController)
            settingsViewController.viewModel = SettingsViewModel(withRouter: router)
            navigationController.tabBarItem.image = AppearanceController.theme == .darkTheme ? #imageLiteral(resourceName: "img_tabbar_profile").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_profile").withRenderingMode(.alwaysOriginal)
            viewControllers.append(navigationController)
        }
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
        guard let navigationController = getAssetsNavigationController() else { return }
        setWindowRoot(viewController: navigationController)
        signInAction(navigationController)
    }
    
    func startAsUnauthorized() {
        guard let navigationController = getAssetsNavigationController() else { return }
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
    
    func signInAction(_ navigationController: BaseNavigationController? = nil) {
        guard let viewController = SignInViewController.storyboardInstance(name: .auth) else { return }
        let router = SignInRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = AuthSignInViewModel(withRouter: router)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func showProgramDetails(with programId: String) {
        guard let viewController = getDetailsViewController(with: programId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showFundDetails(with fundId: String) {
        guard let viewController = getFundDetailsViewController(with: fundId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showNotificationList() {
        guard let viewController = NotificationListViewController.storyboardInstance(name: .dashboard) else { return }
        
        let router = NotificationListRouter(parentRouter: self)
        viewController.viewModel = NotificationListViewModel(withRouter: router, reloadDataProtocol: viewController)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showEvents(with assetId: String? = nil) {
        guard let viewController = getEventsViewController(with: assetId) else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCreateProgramVC() {
        let tabmanViewController = CreateProgramTabmanViewController()
        let router = CreateProgramTabmanRouter(parentRouter: self, tabmanViewController: tabmanViewController)
        let viewModel = CreateProgramTabmanViewModel(withRouter: router, tabmanViewModelDelegate: tabmanViewController)
        tabmanViewController.viewModel = viewModel
        tabmanViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(tabmanViewController, animated: true)
    }
    
    func showPrivacy() {
        navigationController?.openSafariVC(with: Constants.Urls.privacyWebAddress)
    }
    
    func showTerms() {
        navigationController?.openSafariVC(with: Constants.Urls.termsWebAddress)
    }
    
    func getEventsViewController(with assetId: String? = nil, router: Router? = nil, allowsSelection: Bool = true) -> AllEventsViewController? {
        guard let viewController = AllEventsViewController.storyboardInstance(name: .dashboard) else { return nil }
        
        viewController.viewModel = AllEventsViewModel(withRouter: router ?? AllEventsRouter(parentRouter: self), assetId: assetId, reloadDataProtocol: viewController, allowsSelection: allowsSelection)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getDetailsViewController(with programId: String) -> ProgramViewController? {
        guard let programViewController = ProgramViewController.storyboardInstance(name: .program) else {
            return nil
        }
        programViewController.viewModel = ProgramViewModel(withRouter: self, programId: programId, programViewController: programViewController)

        programViewController.hidesBottomBarWhenPushed = true
        return programViewController
    }
    
    func getFundDetailsViewController(with fundId: String) -> FundViewController? {
        guard let fundViewController = FundViewController.storyboardInstance(name: .fund) else {
            return nil
        }
        fundViewController.viewModel = FundViewModel(withRouter: self, fundId: fundId, fundViewController: fundViewController)
        
        fundViewController.hidesBottomBarWhenPushed = true
        return fundViewController
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
