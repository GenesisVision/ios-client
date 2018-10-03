//
//  Protocols.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

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

protocol UIViewControllerWithTableView {
    var tableView: UITableView! { get }
    var refreshControl: UIRefreshControl! { get }
}

protocol Hidable {
    func hideAll()
}

extension Hidable where Self: UIViewController {
    func hideAll() {
        hideHUD()
    }
}

protocol UIViewControllerWithFetching {
    var fetchMoreActivityIndicator: UIActivityIndicatorView! { get }
    
    func updateData()
    func setupPullToRefresh(title: String?)
    func pullToRefresh()
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
    var sortAndFilterStackView: UIStackView { get }
    var bottomStackView: UIStackView { get }
    var bottomViewType: BottomViewType { get }
    
    func sortButtonAction()
    func filterButtonAction()
    func signInButtonAction()
}

extension UIViewControllerWithBottomView where Self: BaseViewController {
    func signInButtonAction() {
        
    }
    
    func filterButtonAction() {
        
    }
    
    func sortButtonAction() {
        
    }
}

