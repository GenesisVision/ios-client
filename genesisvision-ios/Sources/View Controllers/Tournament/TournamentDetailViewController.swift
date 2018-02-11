//
//  TournamentDetailViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TournamentDetailViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: TournamentDetailViewModel!
    
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

extension TournamentDetailViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
}
