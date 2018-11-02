//
//  Protocols.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol NodataProtocol {
    var noDataTitle: String? { get }
    var noDataImage: UIImage? { get }
    var noDataButtonTitle: String? { get }
}

protocol YourInvestmentProtocol: class {
    func didTapWithdrawButton()
    func didTapStatusButton()
    func didChangeReinvestSwitch(value: Bool)
}

extension YourInvestmentProtocol {
    func didTapWithdrawButton() {
        
    }
    func didTapStatusButton() {
        
    }
    
    func didChangeReinvestSwitch(value: Bool) {
        
    }
}

protocol ReinvestProtocol: class {
    func didChangeReinvestSwitch(value: Bool, assetId: String)
}

extension ReinvestProtocol {
    func didChangeReinvestSwitch(value: Bool, indexPath: IndexPath) {
        
    }
}

protocol DelegateManagerProtocol: class {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView)
    func delegateManagerScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func delegateManagerTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
}

//old ProgramProtocol
protocol FavoriteStateChangeProtocol: class {
    func didChangeFavoriteState(with programID: String, value: Bool, request: Bool)
}

protocol FavoriteStateUpdatedProtocol: class {
    func didFavoriteStateUpdated()
}

protocol CurrencyTitleButtonProtocol {
    var target: Any? { get }
    var action: Selector! { get }
}

protocol ViewModelWithTableView {
    var tableViewDataSourceAndDelegate: TableViewDataSourceAndDelegate! { get }
    
    func headerTitle(for section: Int) -> String?
    func headerHeight(for section: Int) -> CGFloat
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func model(at indexPath: IndexPath) -> CellViewAnyModel?
}

extension ViewModelWithTableView {func headerTitle(for section: Int) -> String? {
    return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 1.0
    }
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
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
    var bottomSheetController: BottomSheetController! { get }
}

protocol UIViewControllerWithFetching {
    var fetchMoreActivityIndicator: UIActivityIndicatorView! { get }
    
    func updateData()
    func fetch()
    func fetchMore()
    
    func showInfiniteIndicator(value: Bool)
}

extension UIViewControllerWithFetching where Self: UITableViewController {
    func showInfiniteIndicator(value: Bool) {
        guard value, fetchMoreActivityIndicator != nil else {
            tableView.tableFooterView = UIView()
            return
        }
        
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
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

