
//
//  ProgramDetailViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ViewAnimator

class ProgramDetailViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: ProgramDetailViewModel! {
        didSet {
            title = viewModel.getNickname()
            
            updateData()
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var investButton: UIButton!
    @IBOutlet var withdrawButton: UIButton!
    
    // MARK: - Variables
    private var refreshControl: UIRefreshControl!
    private var historyBarButtonItem: UIBarButtonItem?
    private let tableViewAnimation = AnimationType.from(direction: .left, offset: 30.0)
    
    // MARK: - IBOutlets
    @IBOutlet var buttonsView: UIView!
    @IBOutlet weak var investButtonViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var investButtonViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var withdrawButtonViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideHUD()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        historyBarButtonItem = UIBarButtonItem(title: "History", style: .done, target: self, action: #selector(historyButtonAction(_:)))
        navigationItem.rightBarButtonItem = historyBarButtonItem
        
        investButton.tintColor = UIColor.Font.green
        withdrawButton.tintColor = UIColor.Font.red
        
        investButtonViewTrailingConstraint.isActive = true
        investButtonViewWidthConstraint.isActive = false
        withdrawButtonViewLeadingConstraint.isActive = false
        withdrawButton.isHidden = true
        
        switch viewModel.state {
        case .show:
            investButtonViewTrailingConstraint.constant = 32
            navigationItem.rightBarButtonItem = nil
        case .invest:
            investButtonViewTrailingConstraint.constant = 32
        case .full:
            investButtonViewTrailingConstraint.isActive = false
            investButtonViewWidthConstraint.isActive = true
            withdrawButtonViewLeadingConstraint.isActive = true
            withdrawButton.isHidden = false
        }
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorStyle = .none
        tableView.registerNibs(for: ProgramDetailViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: ProgramDetailViewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func setupPullToRefresh() {
        let tintColor = UIColor.primary
        let attributes = [NSAttributedStringKey.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: attributes)
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh() {
        refreshControl?.endRefreshing()
    }
    
    private func updateData() {
//        showProgressHUD()
//        pullToRefresh()
    }
    
    // MARK: - IBActions
    @IBAction func historyButtonAction(_ sender: UIButton) {
        viewModel.showHistory()
    }
    
    @IBAction func investButtonAction(_ sender: UIButton) {
        viewModel.invest()
    }
    
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        viewModel.withdraw()
    }
}

extension ProgramDetailViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
        header.headerLabel.text = title
        return header
    }
}

extension ProgramDetailViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        updateData()
    }
}
