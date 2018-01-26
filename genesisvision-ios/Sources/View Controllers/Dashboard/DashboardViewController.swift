//
//  DashboardViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {

    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Dashboard"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
