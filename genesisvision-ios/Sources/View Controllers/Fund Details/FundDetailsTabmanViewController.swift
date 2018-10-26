//
//  FundDetailsTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundDetailsTabmanViewController: BaseTabmanViewController<FundDetailsViewModel> {
    
    // MARK: - Variables
    weak var fundInfoViewControllerProtocol: FavoriteStateChangeProtocol?
    var scrollEnabled: Bool = true {
        didSet {
            //TODO:
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.bounces = false
    }
    
    // MARK: - Public Methods
    func setup(_ fundDetailsFull: FundDetailsFull?) {
        viewModel.setup(fundDetailsFull)
    }
}

extension FundDetailsTabmanViewController: ReloadDataProtocol {
    func didReloadData() {
        if let viewModel = viewModel {
            viewModel.reloadDetails()
        }
    }
}

