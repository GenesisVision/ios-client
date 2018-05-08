//
//  DashboardTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Tabman

class DashboardTabmanViewController: BaseTabmanViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bar.delegate = self
    }
}

extension DashboardTabmanViewController: TabmanBarDelegate {
    func bar(shouldSelectItemAt index: Int) -> Bool {
        return true
    }
}
