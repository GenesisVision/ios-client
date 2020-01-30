//
//  ListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    // MARK: - Variables
    var tableView: UITableView!
    
    var fetchMoreActivityIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl?
    var isEnablePullToRefresh: Bool = true
    var isEnableInfiniteIndicator: Bool = false {
        didSet {
            if isEnableInfiniteIndicator {
                fetchMoreActivityIndicator = UIActivityIndicatorView(style: .gray)
                fetchMoreActivityIndicator.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
                fetchMoreActivityIndicator.color = UIColor.primary
                tableView.tableFooterView = fetchMoreActivityIndicator
                fetchMoreActivityIndicator.startAnimating()
            } else {
                tableView.tableFooterView = UIView()
            }
        }
    }
    
    lazy var bottomSheetController: BottomSheetController = {
        return BottomSheetController()
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
    }
    
    // MARK: - Methods
    func addTableView() {
        if tableView == nil {
            tableView = UITableView(frame: .zero, style: .grouped)
            tableView.backgroundColor = UIColor.BaseView.bg
            tableView.separatorStyle = .none
            
            self.view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
            ])
        
            var frame = CGRect.zero
            frame.size.height = .leastNormalMagnitude
            tableView.tableHeaderView = UIView(frame: frame)
            
            if isEnablePullToRefresh {
                setupPullToRefresh(scrollView: tableView)
            }
        }
    }
    
    func showInfiniteIndicator(_ value: Bool) {
        guard fetchMoreActivityIndicator != nil else { return }
        
        value ? fetchMoreActivityIndicator.startAnimating() : fetchMoreActivityIndicator.stopAnimating()
    }
}

extension ListViewController: UIViewControllerWithPullToRefresh {
    @objc func pullToRefresh() {
        impactFeedback()
    }
    
    func setupPullToRefresh(title: String? = nil, scrollView: UIScrollView) {
        let tintColor = UIColor.primary
        let attributes = [NSAttributedString.Key.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        if let title = title {
            refreshControl?.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        }
        refreshControl?.tintColor = tintColor
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
}
