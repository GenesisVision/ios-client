//
//  TabmanRouter.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Tabman

class TabmanRouter: Router {

    var tabmanViewController: TabmanViewController?

    init(parentRouter: Router?, tabmanViewController: TabmanViewController? = nil, navigationController: UINavigationController? = nil) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        self.tabmanViewController = tabmanViewController
        self.currentController = tabmanViewController
    }
    
    func next() {
        tabmanViewController?.scrollToPage(.next, animated: true)
    }
    
    func previous() {
        tabmanViewController?.scrollToPage(.previous, animated: true)
    }
}
