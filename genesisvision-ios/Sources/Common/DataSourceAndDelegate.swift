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

