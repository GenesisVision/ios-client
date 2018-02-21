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
    var canFetchMoreResults: Bool { get }
}

protocol UIViewControllerWithFetching {
    func updateData()
    func pullToRefresh()
    
    func fetchMore()
}
