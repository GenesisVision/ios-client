
//
//  TraderViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TraderViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: ProgramDetailViewModel!
    
    // MARK: - Variables
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        title = viewModel.getNickname()
    }
    
    private func setupTableConfiguration() {
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
}

extension TraderViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
}
