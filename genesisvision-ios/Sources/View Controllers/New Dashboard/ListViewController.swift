//
//  ListViewController.swift
//  genesisvision-ios
//
//  Created by George on 27.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
    }
    
    func addTableView() {
        if tableView == nil {
            tableView = UITableView(frame: .zero, style: .plain)
            self.view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        }
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
