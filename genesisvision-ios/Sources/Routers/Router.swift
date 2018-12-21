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
    case dashboard, assetList, wallet, profile
}

class Router {
    // MARK: - Variables
    var investorDashboardViewController: InvestorDashboardViewController!
    var managerDashboardViewController: ManagerDashboardViewController!
    
    var programsViewController: ProgramListViewController!
    var fundsViewController: FundListViewController!
    var managersViewController: ManagerListViewController!

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
        self.managersViewController = parentRouter?.managersViewController
        
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
        let viewModel = AssetsTabmanViewModel(withRouter: router, searchBarEnable: true, showFacets: true)
        assetsViewController.viewModel = viewModel
        
        return navigationController
    }
    
    private func addDashboard(_ navigationController: inout BaseNavigationController, _ viewControllers: inout [UIViewController]) {
        
        if isInvestorApp, let viewController = InvestorDashboardViewController.storyboardInstance(.dashboard) {
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
        guard let walletViewController = WalletViewController.storyboardInstance(.wallet) else { return }
        navigationController = BaseNavigationController(rootViewController: walletViewController)
        let router = WalletRouter(parentRouter: self, navigationController: navigationController)
        walletViewController.viewModel = WalletControllerViewModel(withRouter: router)
        navigationController.tabBarItem.image = AppearanceController.theme == .darkTheme ? #imageLiteral(resourceName: "img_tabbar_wallet").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_wallet").withRenderingMode(.alwaysOriginal)
        viewControllers.append(navigationController)
    }
    
    private func addSettings(_ navigationController: inout BaseNavigationController, _ viewControllers: inout [UIViewController]) {
        if let settingsViewController = SettingsViewController.storyboardInstance(.settings) {
            navigationController = BaseNavigationController(rootViewController: settingsViewController)
            let router = SettingsRouter(parentRouter: self, navigationController: navigationController)
            settingsViewController.viewModel = SettingsViewModel(withRouter: router)
            navigationController.tabBarItem.image = AppearanceController.theme == .darkTheme ? #imageLiteral(resourceName: "img_tabbar_profile").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "img_tabbar_profile").withRenderingMode(.alwaysOriginal)
            viewControllers.append(navigationController)
        }
    }
    
    private func showProgramList(with filterModel: FilterModel) {
        guard let viewController = getPrograms(with: filterModel) else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showFundList(with filterModel: FilterModel) {
        guard let viewController = getFunds(with: filterModel) else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showManagerList(with filterModel: FilterModel) {
        guard let viewController = getManagers(with: filterModel) else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
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
    
    func showNotificationsSettings() {
        guard let viewController = getNotificationsSettingsViewController() else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAssetNotificationsSettings(_ assetId: String?, title: String, type: NotificationSettingsType) {
        guard let viewController = getAssetNotificationsSettingsViewController(assetId, type: type) else { return }
        viewController.title = title
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showRatingList(with filterModel: FilterModel) {
        guard let viewController = getRating(with: filterModel) else { return }
        
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
        guard let viewController = SignInViewController.storyboardInstance(.auth) else { return }
        let router = SignInRouter(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = AuthSignInViewModel(withRouter: router)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func showAssetDetails(with assetId: String, assetType: AssetType) {
        switch assetType {
        case .program:
            showProgramDetails(with: assetId)
        case .fund:
            showFundDetails(with: assetId)
        case .manager:
            showManagerDetails(with: assetId)
        }
    }
    
    func showFilterVC(with listViewModel: ListViewModelProtocol, filterModel: FilterModel, filterType: FilterType, sortingType: SortingType) {
        guard let viewController = FiltersViewController.storyboardInstance(.programs) else { return }
        let router = ProgramFilterRouter(parentRouter: self, navigationController: navigationController)
        router.currentController = viewController
        let viewModel = FilterViewModel(withRouter: router, sortingType: sortingType, filterViewModelProtocol: viewController, filterModel: filterModel, listViewModel: listViewModel, filterType: filterType)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showProgramDetails(with programId: String) {
        guard let viewController = getProgramViewController(with: programId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showFundDetails(with fundId: String) {
        guard let viewController = getFundViewController(with: fundId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showManagerDetails(with managerId: String) {
        guard let viewController = getManagerViewController(with: managerId) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAssetList(with filterModel: FilterModel, assetType: AssetType) {
        switch assetType {
        case .program:
            showProgramList(with: filterModel)
        case .fund:
            showFundList(with: filterModel)
        case .manager:
            showManagerList(with: filterModel)
        }
    }
    
    func showAboutLevels() {
        guard let viewController = AboutLevelsViewController.storyboardInstance(.program) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showNotificationList() {
        guard let viewController = NotificationListViewController.storyboardInstance(.notifications) else { return }
        
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
        navigationController?.openSafariVC(with: Urls.privacyWebAddress)
    }
    
    func showTerms() {
        navigationController?.openSafariVC(with: Urls.termsWebAddress)
    }
    
    func getEventsViewController(with assetId: String? = nil, router: Router? = nil, allowsSelection: Bool = true) -> AllEventsViewController? {
        guard let viewController = AllEventsViewController.storyboardInstance(.dashboard) else { return nil }
        
        viewController.viewModel = AllEventsViewModel(withRouter: router ?? AllEventsRouter(parentRouter: self), assetId: assetId, reloadDataProtocol: viewController, allowsSelection: allowsSelection)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getProgramViewController(with programId: String) -> ProgramViewController? {
        guard let viewController = ProgramViewController.storyboardInstance(.program) else {
            return nil
        }
        let router = ProgramRouter(parentRouter: self, navigationController: navigationController, programViewController: viewController)
        let viewModel = ProgramViewModel(withRouter: router, programId: programId, programViewController: viewController)
        viewController.viewModel = viewModel

        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getFundViewController(with fundId: String) -> FundViewController? {
        guard let viewController = FundViewController.storyboardInstance(.fund) else {
            return nil
        }
        let router = FundRouter(parentRouter: self, navigationController: navigationController, fundViewController: viewController)
        let viewModel = FundViewModel(withRouter: router, fundId: fundId, fundViewController: viewController)
        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getManagerViewController(with managerId: String) -> ManagerViewController? {
        guard let viewController = ManagerViewController.storyboardInstance(.manager) else {
            return nil
        }
        let router = ManagerRouter(parentRouter: self, navigationController: navigationController, managerViewController: viewController)
        let viewModel = ManagerViewModel(withRouter: router, managerId: managerId, managerViewController: viewController)
        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getTwoFactorEnableViewController() -> AuthTwoFactorTabmanViewController? {
        let tabmanViewController = AuthTwoFactorTabmanViewController()
        let router = AuthTwoFactorTabmanRouter(parentRouter: self, tabmanViewController: tabmanViewController)
        tabmanViewController.viewModel = AuthTwoFactorTabmanViewModel(withRouter: router, tabmanViewModelDelegate: tabmanViewController)
        tabmanViewController.hidesBottomBarWhenPushed = true
        
        return tabmanViewController
    }
    
    func getNotificationsSettingsViewController() -> NotificationsSettingsViewController? {
        guard let viewController = NotificationsSettingsViewController.storyboardInstance(.notifications) else { return nil }
        
        viewController.viewModel = NotificationsSettingsViewModel(withRouter: self, reloadDataProtocol: viewController, type: .all)
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
    
    func getAssetNotificationsSettingsViewController(_ assetId: String?, type: NotificationSettingsType) -> NotificationsSettingsViewController? {
        guard let viewController = NotificationsSettingsViewController.storyboardInstance(.notifications) else { return nil }
        
        viewController.viewModel = NotificationsSettingsViewModel(withRouter: self, reloadDataProtocol: viewController, type: type, assetId: assetId)
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
    
    func getTwoFactorDisableViewController() -> AuthTwoFactorConfirmationViewController? {
        guard let viewController = AuthTwoFactorConfirmationViewController.storyboardInstance(.auth) else { return nil }
        let router = AuthTwoFactorDisableRouter(parentRouter: self)
        viewController.viewModel = AuthTwoFactorDisableConfirmationViewModel(withRouter: router)
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
    
    func getPrograms(with filterModel: FilterModel?, showFacets: Bool = false, parentRouter: Router? = nil) -> ProgramListViewController? {
        guard let viewController = ProgramListViewController.storyboardInstance(.programs) else { return nil }
        
        let router = ListRouter(parentRouter: parentRouter ?? self)
        router.currentController = viewController
        let viewModel = ListViewModel(withRouter: router, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .program)

        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getFunds(with filterModel: FilterModel?, showFacets: Bool = false, parentRouter: Router? = nil) -> FundListViewController? {
        guard let viewController = FundListViewController.storyboardInstance(.funds) else { return nil }
        
        let router = ListRouter(parentRouter: parentRouter ?? self)
        router.currentController = viewController
        let viewModel = ListViewModel(withRouter: router, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .fund)
        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getManagers(with filterModel: FilterModel?, showFacets: Bool = false, parentRouter: Router? = nil) -> ManagerListViewController? {
        guard let viewController = ManagerListViewController.storyboardInstance(.manager) else { return nil }
        
        let router = ListRouter(parentRouter: parentRouter ?? self)
        router.currentController = viewController
        let viewModel = ManagerListViewModel(withRouter: router, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets)
        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func getRating(with filterModel: FilterModel?) -> RatingViewController? {
        let viewController = RatingViewController()
        
        let router = Router(parentRouter: self, navigationController: navigationController)
        router.currentController = viewController
        
        let viewModel = RatingTabmanViewModel(withRouter: router, tabmanViewModelDelegate: viewController)
        viewController.viewModel = viewModel
        
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
