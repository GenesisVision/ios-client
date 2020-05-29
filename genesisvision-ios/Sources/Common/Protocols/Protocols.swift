//
//  Protocols.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

protocol BaseTableViewProtocol: class {
    func action(_ type: CellActionType, actionType: ActionType)
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?)
    func didSelect(_ type: DidSelectType, index: Int)
    func didReload()
    func didReload(_ indexPath: IndexPath)
    func didShowInfiniteIndicator(_ value: Bool)
}

extension BaseTableViewProtocol{
    func action(_ type: CellActionType, actionType: ActionType) {
        
    }
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        
    }
    func didSelect(_ type: DidSelectType, index: Int) {
        
    }
    func didReload() {
        
    }
    func didReload(_ indexPath: IndexPath) {
        
    }
    func didShowInfiniteIndicator(_ value: Bool) {
        
    }
}

extension BaseTableViewProtocol where Self: ListViewController {
    func didReload() {
        hideHUD()
        refreshControl?.endRefreshing()
        tableView.reloadDataSmoothly()
    }
}

@objc protocol BaseTableViewCellProtocol {
    weak var titleLabel: LargeTitleLabel! { get set }
    weak var rightButtonsView: UIStackView! { get set }
}
@objc protocol BaseTableViewCellWithCollection {
    weak var collectionView: UICollectionView! { get set }
    
    func collectionSetup()
}

protocol NodataProtocol {
    var noDataTitle: String? { get }
    var noDataImage: UIImage? { get }
    var noDataButtonTitle: String? { get }
}

protocol YourInvestmentProtocol: class {
    func didTapWithdrawButton()
    func didTapDepositButton()
    func didTapStatusButton()
    func didChangeSwitch(value: Bool)
}

extension YourInvestmentProtocol {
    func didTapWithdrawButton() {
        
    }
    func didTapDepositButton() {
        
    }
    func didTapStatusButton() {
        
    }
    func didChangeSwitch(value: Bool) {
        
    }
}

protocol AccountMakeProgramProtocol: class {
    func didTapMakeProgramButton()
}

protocol AccountMakeFollowProtocol: class {
    func didTapMakeFollowButton()
}

protocol AccountSubscriptionsProtocol: class {
    func didTapDetailsButton()
}

protocol WalletActionsProtocol: class {
    func didTapWithdrawButton()
    func didTapAddFundsButton()
    func didTapTransferButton()
}

protocol NotificationsSettingsProtocol: class {
    func didChange(enable: Bool, settingId: String?)
    func didRemove(settingId: String?)
    func didAdd(type: NotificationType?)
    func didAdd(assetId: String?, type: NotificationType?, conditionType: NotificationSettingConditionType?, conditionAmount: Double?)
}

protocol SwitchProtocol: class {
    func didChangeSwitch(value: Bool, assetId: String)
}

protocol DelegateManagerProtocol: class {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView)
    func delegateManagerScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func delegateManagerTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func delegateManagerTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

extension DelegateManagerProtocol {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    func delegateManagerScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    func delegateManagerTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    func delegateManagerTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

protocol CurrencyDelegateManagerProtocol: UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView? { get set }
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
}

protocol WalletProtocol: class {
    func didUpdateData()
}

protocol ReloadDataProtocol: class {
    func didReloadData()
}
protocol FilterChangedProtocol: class {
    var filterDateRangeModel: FilterDateRangeModel? { get }
}

protocol FavoriteStateChangeProtocol: class {
    func didChangeFavoriteState(with assetID: String, value: Bool, request: Bool)
}
protocol FavoriteStateUpdatedProtocol: class {
    func didFavoriteStateUpdated()
}

protocol CurrencyTitleButtonProtocol {
    var target: Any? { get }
    var action: Selector! { get }
}

protocol ViewModelWithTableView {
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func model(for indexPath: IndexPath) -> CellViewAnyModel?
}

extension ViewModelWithTableView {func headerTitle(for section: Int) -> String? {
    return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return nil
    }
}

protocol BaseViewControllerWithViewModel {
    var viewModel: ViewModelWithTableView! { get }
}

@objc protocol UIViewControllerWithTableView {
    var tableView: UITableView! { get }
}

@objc protocol UIViewControllerWithScrollView {
    var scrollView: UIScrollView! { get }
}

protocol UIViewControllerWithPullToRefresh {
    var refreshControl: UIRefreshControl? { get }
    
    func setupPullToRefresh(title: String?, scrollView: UIScrollView)
    func pullToRefresh()
}

protocol Hidable {
    func hideAll()
}

extension Hidable where Self: UIViewController {
    func hideAll() {
        hideHUD()
    }
}

protocol UIViewControllerWithBottomSheet {
    var bottomSheetController: BottomSheetController { get }
}

protocol UIViewControllerWithFetching {
    var fetchMoreActivityIndicator: UIActivityIndicatorView! { get }
    var isEnableInfiniteIndicator: Bool { get }
    
    func updateData()
    func fetch()
    func fetchMore()
    
    func showInfiniteIndicator(value: Bool)
}

extension UIViewControllerWithFetching where Self: UITableViewController {
    func showInfiniteIndicator(value: Bool) {
        guard fetchMoreActivityIndicator != nil else { return }
        
        value ? fetchMoreActivityIndicator.startAnimating() : fetchMoreActivityIndicator.stopAnimating()
    }
}

protocol UIViewControllerWithBottomView {
    var sortButton: ActionButton { get }
    var filterButton: ActionButton { get }
    var signInButton: ActionButton { get }
    var filterStackView: UIStackView { get }
    var bottomStackView: UIStackView { get }
    var bottomViewType: BottomViewType { get }
    
    func sortButtonAction()
    func filterButtonAction()
    func signInButtonAction()
    func dateRangeButtonAction()
}

extension UIViewControllerWithBottomView where Self: BaseViewController {
    func signInButtonAction() {
        
    }
    
    func filterButtonAction() {
        
    }
    
    func sortButtonAction() {
        
    }
    
    func dateRangeButtonAction() {
        
    }
}

protocol WalletListViewModelProtocol {
    var title: String { get }
    var totalCount: Int { get }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] { get }
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] { get }
    
    func fetch(completion: @escaping CompletionBlock)
    func refresh(completion: @escaping CompletionBlock)
    
    func fetchMore(at indexPath: IndexPath) -> Bool
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    func model(for indexPath: IndexPath) -> CellViewAnyModel?
    
    func showAssetDetails(with assetId: String, assetType: AssetType)
    
    func logoImageName() -> String
    func noDataText() -> String
    func noDataImageName() -> String?
    func noDataButtonTitle() -> String
}

protocol WalletDelegateManagerProtocol: class {
    func didSelectWallet(at indexPath: IndexPath, walletId: Int)
}

protocol TabmanDataSourceProtocol {
    func getCount() -> Int
    func getItem(_ index: Int) -> TMBarItem?
    func getViewController(_ index: Int) -> UIViewController?
}

// MARK: - DashboardTradingAcionsProtocol
protocol DashboardTradingAcionsProtocol {
    func makeProgram(_ asset: DashboardTradingAsset)
    func makeSignal(_ asset: DashboardTradingAsset)
    func changePassword(_ asset: DashboardTradingAsset)
    func openSettings(_ asset: DashboardTradingAsset)
    func closePeriod(_ asset: DashboardTradingAsset)
}
extension DashboardTradingAcionsProtocol where Self: ListViewController {
    func makeProgram(_ asset: DashboardTradingAsset) {
        guard let vc = MakeProgramViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Make program"
        vc.viewModel.request._id = asset._id
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    func makeSignal(_ asset: DashboardTradingAsset) {
        guard let vc = MakeSignalViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Make signal"
        vc.viewModel.request._id = asset._id
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    func changePassword(_ asset: DashboardTradingAsset) {
        //TODO:
    }
    func openSettings(_ asset: DashboardTradingAsset) {
        //TODO:
    }
    func closePeriod(_ asset: DashboardTradingAsset) {
        guard let assetId = asset._id?.uuidString else { return }
        let model = TradingAccountPwdUpdate(password: nil, twoFactorCode: nil)
        showProgressHUD()
        AssetsDataProvider.closeCurrentPeriod(assetId, model: model) { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}
