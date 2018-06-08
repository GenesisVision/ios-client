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

    init(parentRouter: Router?, tabmanViewController: TabmanViewController? = nil) {
        super.init(parentRouter: parentRouter)
        self.tabmanViewController = tabmanViewController
    }
    
    func next() {
        tabmanViewController?.scrollToPage(.next, animated: true)
    }
    
    func previous() {
        tabmanViewController?.scrollToPage(.previous, animated: true)
    }
}
