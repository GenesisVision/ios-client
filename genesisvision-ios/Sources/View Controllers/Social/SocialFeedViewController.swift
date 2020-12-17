//
//  SocialFeedViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit


class SocialFeedViewController: BaseViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var viewModel: SocialFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Social"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.fillSuperview(padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        setupPullToRefresh(scrollView: tableView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
        }, refresh: true)
    }
}


extension SocialFeedViewController: BaseTableViewProtocol {
    func didReload() {
        DispatchQueue.main.async {
            self.tableView.reloadDataSmoothly()
        }
    }
}
