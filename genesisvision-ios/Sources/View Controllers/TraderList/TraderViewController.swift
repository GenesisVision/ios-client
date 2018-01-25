
//
//  TraderViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TraderViewController: BaseViewController {

    var traderEntity: InvestmentProgramEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = traderEntity?.nickname
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
