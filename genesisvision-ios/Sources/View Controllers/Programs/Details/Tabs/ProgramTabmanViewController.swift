//
//  ProgramTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramTabmanViewController: BaseTabmanViewController<ProgramTabmanViewModel> {
    
    // MARK: - Variables
    weak var programInfoViewControllerProtocol: FavoriteStateChangeProtocol?
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
    func setup(_ programDetailsFull: ProgramDetailsFull?) {
        viewModel.setup(programDetailsFull)
    }
}

extension ProgramTabmanViewController: ReloadDataProtocol {
    func didReloadData() {
        if let viewModel = viewModel {
            viewModel.reloadDetails()
        }
    }
}
