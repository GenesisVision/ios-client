//
//  BasePageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 03/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Pageboy

protocol BasePageboyProtocol {
    func setup(router: Router, showFacets: Bool)
    func setup(router: Router, wallet: WalletData?)
}

class BasePageboyViewControllerDataSource: NSObject, PageboyViewControllerDataSource, BasePageboyProtocol {
    
    var controllers = [BaseViewController]()
    
    init(router: Router, showFacets: Bool) {
        super.init()
        
        setup(router: router, showFacets: showFacets)
    }
    
    init(router: Router, wallet: WalletData? = nil) {
        super.init()
        
        setup(router: router, wallet: wallet)
    }
    
    init(router: Router, account: CopyTradingAccountInfo? = nil) {
        super.init()
        
        setup(router: router, account: account)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return controllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return controllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }
    
    // MARK: - Private methods
    internal func setup(router: Router, showFacets: Bool) {
    }
    
    internal func setup(router: Router, wallet: WalletData? = nil) {
    }
    
    internal func setup(router: Router, account: CopyTradingAccountInfo? = nil) {
    }
}
