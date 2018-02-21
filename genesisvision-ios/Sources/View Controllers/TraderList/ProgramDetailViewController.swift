
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
        
        investButton.tintColor = UIColor.Button.green
        withdrawButton.tintColor = UIColor.Button.red
        
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
        tableView.separatorStyle = .none
        tableView.registerNibs(for: ProgramDetailViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: ProgramDetailViewModel.viewModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    override func pullToRefresh() {
        //Fetch
        hideHUD()
        reloadData()
    }
    
    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
        tableView.animateViews(animations: [tableViewAnimation])
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

