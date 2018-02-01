//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfileViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: ProfileViewModel!
    
    // MARK: - Variables
    @IBOutlet var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Variables
    private var signOutButton: UIBarButtonItem?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        signOutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(signOutButtonAction(_:)))
        navigationItem.rightBarButtonItem = signOutButton
        
        title = isInvestorApp
            ? "Investor Profile"
            : "Manager Profile"
    }
    
    private func setupTableConfiguration() {
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    
    // MARK: - Actions
    @IBAction func signOutButtonAction(_ sender: UIButton) {
        viewModel.signOut()
    }
}

extension ProfileViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
}
