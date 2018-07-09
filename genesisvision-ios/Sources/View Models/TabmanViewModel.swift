//
//  TabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

protocol TabmanViewModelProtocol {
    func initializeViewControllers()
}

protocol TabmanViewModelDelegate: class {
    func updatedItems()
}

class TabmanViewModel: TabmanViewModelProtocol {
    // MARK: - Variables
    var title: String = ""
    
    weak var tabmanViewModelDelegate: TabmanViewModelDelegate?
    
    internal var style: TabmanBar.Style = .buttonBar
    internal var location: TabmanBar.Location = .top
    internal var bounces = true
    internal var compresses = false
    internal var isScrollEnabled = true
    internal var isProgressive = false
    internal var itemDistribution: TabmanBar.Appearance.Layout.ItemDistribution = .leftAligned
    internal var shouldHideWhenSingleItem = false
    internal var router: Router!
    
    var viewControllersCount: Int = 1
    public private(set) var viewControllers = [UIViewController]()
    public private(set) var itemTitles = [String]()
    
    public private(set) var defaultPage: PageboyViewController.Page? = .first
    
    // MARK: - Init
    init(withRouter router: Router, viewControllersCount: Int = 1, defaultPage: Int = 0, tabmanViewModelDelegate: TabmanViewModelDelegate?) {
        self.router = router
        self.defaultPage = .at(index: defaultPage)
        self.viewControllersCount = viewControllersCount
        self.tabmanViewModelDelegate = tabmanViewModelDelegate
    }
    
    // MARK: - Public methods
    func addItem(_ item: String) {
        itemTitles.append(item)
        tabmanViewModelDelegate?.updatedItems()
    }
    
    func addController(_ viewController: UIViewController) {
        viewControllers.append(viewController)
        viewControllersCount = viewControllers.count
        style = viewControllersCount > 4 ? .scrollingButtonBar : .buttonBar
    }
    
    func removeController(_ index: Int) {
        viewControllers.remove(at: index)
        itemTitles.remove(at: index)
        viewControllersCount = viewControllers.count
        tabmanViewModelDelegate?.updatedItems()
    }
    
    func removeAllControllers() {
        viewControllers.removeAll()
        itemTitles.removeAll()
        viewControllersCount = viewControllers.count
    }
        
    func reloadPages() {
        if let vc = self.router.currentController as? TabmanViewController {
            vc.reloadPages()
        }
        
        if let vc = self.router.currentController as? ProgramDetailsTabmanViewController {
            vc.didReloadData()
        }
    }
    
    func initializeViewControllers() {
        //Set ViewControllers
    }
}
