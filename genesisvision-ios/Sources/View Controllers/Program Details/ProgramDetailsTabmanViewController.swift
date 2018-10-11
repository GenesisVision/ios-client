//
//  ProgramDetailsTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIBarButtonItem

protocol ProgramInfoViewControllerProtocol: class {
    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool)
}

class ProgramDetailsTabmanViewController: BaseTabmanViewController<ProgramDetailsViewModel> {
    
    // MARK: - Variables
    weak var programDetailViewControllerProtocol: ProgramInfoViewControllerProtocol?
    var scrollEnabled: Bool = true {
        didSet {
            //TODO:
        }
    }
    
    // MARK: - Public Methods
    func setup(_ programDetailsFull: ProgramDetailsFull?) {
        viewModel.setup(programDetailsFull)
    }
}

extension ProgramDetailsTabmanViewController: ReloadDataProtocol {
    func didReloadData() {
        if let viewModel = viewModel {
            viewModel.reloadDetails()
        }
    }
}
