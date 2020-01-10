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

class TabmanViewModel {
    // MARK: - Variables
    var title: String = ""
    var items: [TMBarItem]?
    
    var dataSource: PageboyDataSource?
    
    internal var isButtonType: Bool = true
    internal var bounces = true
    internal var compresses = false
    internal var backgroundColor: UIColor = UIColor.BaseView.bg
    internal var font = UIFont.getFont(.semibold, size: 12)
    internal var isScrollEnabled = true
    internal var isProgressive = false
    internal var shouldHideWhenSingleItem = false
    var router: Router!
    
    var viewControllersCount: Int = 1
    public private(set) var defaultPage: PageboyViewController.Page? = .first
    
    // MARK: - Init
    init(withRouter router: Router, viewControllersCount: Int = 1, defaultPage: Int = 0) {
        self.router = router
        self.defaultPage = .at(index: defaultPage)
        self.viewControllersCount = viewControllersCount
    }
}
