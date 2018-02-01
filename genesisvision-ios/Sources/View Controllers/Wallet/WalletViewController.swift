//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class WalletViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: WalletViewModel!
    
    // MARK: - Variables
    @IBOutlet var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let balance = viewModel.getBalance()
        navigationItem.title = String(describing: balance) + " GVT"
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    
    private func fetch() {
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                let balance = self?.viewModel.getBalance()
                self?.navigationItem.title = String(describing: balance) + " GVT"
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
}

extension WalletViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
}
