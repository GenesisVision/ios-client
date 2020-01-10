//
//  DataSourceAndDelegate.swift
//  genesisvision-ios
//
//  Created by George on 13/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView
import Tabman
import Pageboy

class TableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    var viewModel: ViewModelWithTableView!
    
    init(viewModel: ViewModelWithTableView) {
        self.viewModel = viewModel
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class PageboyDataSource: BasePageboyViewControllerDataSource, TMBarDataSource {
    var viewModel: TabmanDataSourceProtocol?
    
    // MARK: - Private methods
    override func setup(_ viewModel: TabmanDataSourceProtocol?) {
        self.viewModel = viewModel
    }
    
    override func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewModel?.getCount() ?? 0
    }
    override func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewModel?.getViewController(index)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return viewModel?.getItem(index) ?? TMBarItem(title: "Empty")
    }
}

