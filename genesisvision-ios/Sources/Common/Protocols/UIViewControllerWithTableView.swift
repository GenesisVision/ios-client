//
//  UIViewControllerWithTableView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol UIViewControllerWithTableView {
    var tableView: UITableView! { get }
    var refreshControl: UIRefreshControl! { get }
}

protocol UIViewControllerWithFetching {
    var fetchMoreActivityIndicator: UIActivityIndicatorView! { get }
    
    func updateData()
    func pullToRefresh()
    func fetch()
    func fetchMore()
}
