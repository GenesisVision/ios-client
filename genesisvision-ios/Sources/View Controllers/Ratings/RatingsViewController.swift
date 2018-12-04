//
//  RatingViewController.swift
//  genesisvision-ios
//
//  Created by George on 03/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class RatingViewController: BaseTabmanViewController<RatingTabmanViewModel> {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func updatedItems() {
        dataSource = viewModel.dataSource
        bar.items = viewModel.items
        reloadPages()
    }
}
