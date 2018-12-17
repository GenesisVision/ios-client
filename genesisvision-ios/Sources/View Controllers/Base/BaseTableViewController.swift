//
//  BaseTableViewController.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, UIViewControllerWithFetching, Hidable, UIViewControllerWithBottomSheet {
    // MARK: - Variables
    var bottomSheetController: BottomSheetController! = {
        return BottomSheetController()
    }()
    
    var fetchMoreActivityIndicator: UIActivityIndicatorView!
    
    var prefersLargeTitles: Bool = true {
        didSet {
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonSetup()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTheme()
    }
    
    // MARK: - Fetching
    func updateData() {
        showProgressHUD()
        fetch()
    }
    
    func fetch() {
        //Fetch first page
    }
    
    func fetchMore() {
        //Fetch next page
    }
    
    func showInfiniteIndicator(value: Bool) {
        guard value, fetchMoreActivityIndicator != nil else {
            tableView.tableFooterView = UIView()
            return
        }
        
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
    }
    
    func hideAll() {
        hideHUD()
        refreshControl?.endRefreshing()
    }
    
    func setupViews() {
        tableView.separatorStyle = .none
        
        fetchMoreActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        fetchMoreActivityIndicator.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        fetchMoreActivityIndicator.color = UIColor.primary
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
        
        tableView.backgroundColor = UIColor.BaseView.bg
        tableView.tableHeaderView?.backgroundColor = UIColor.Cell.headerBg
        
        tableView.separatorInset.left = 16.0
        tableView.separatorInset.right = 16.0
        
        refreshControl?.endRefreshing()
    }
}

extension BaseTableViewController: UIViewControllerWithPullToRefresh {
    
    @objc func pullToRefresh() {
        impactFeedback()
    }
    
    func setupPullToRefresh(title: String? = nil, scrollView: UIScrollView) {
        let tintColor = UIColor.primary
        let attributes = [NSAttributedStringKey.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        if let title = title {
            refreshControl?.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        }
        refreshControl?.tintColor = tintColor
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
}
