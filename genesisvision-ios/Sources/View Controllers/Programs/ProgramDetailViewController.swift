
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
    @IBOutlet var investButton: UIButton! {
        didSet {
            investButton.tintColor = UIColor.Button.green
            investButton.isHidden = true
        }
    }
    @IBOutlet var withdrawButton: UIButton! {
        didSet {
            withdrawButton.tintColor = UIColor.Button.red
            withdrawButton.isHidden = true
        }
    }
    @IBOutlet var requestsButton: UIButton! {
        didSet {
            requestsButton.tintColor = UIColor.Button.primary
            requestsButton.isHidden = true
        }
    }
    
    // MARK: - Variables
    private var historyBarButtonItem: UIBarButtonItem?
    private let tableViewAnimation = AnimationType.from(direction: .left, offset: 30.0)
    
    // MARK: - IBOutlets
    @IBOutlet var buttonsView: UIView!
    
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
        title = viewModel.title
        
        guard let viewProperties = viewModel.viewProperties else { return }
        historyBarButtonItem = UIBarButtonItem(title: "History", style: .done, target: self, action: #selector(historyButtonAction(_:)))
        navigationItem.rightBarButtonItem = viewProperties.isHistoryEnable ? historyBarButtonItem : nil

        investButton.isHidden = !viewProperties.isInvestEnable
        withdrawButton.isHidden = !viewProperties.isWithdrawEnable
        requestsButton.isHidden = !viewProperties.hasNewRequests
        
        var tableViewConfiguration: TableViewConfiguration = .defaultConfig
        
        if viewProperties.hasNewRequests && (viewProperties.isWithdrawEnable || viewProperties.isInvestEnable) {
            tableViewConfiguration.bottomInset = 132.0
        } else if viewProperties.isWithdrawEnable || viewProperties.isInvestEnable || viewProperties.hasNewRequests {
            tableViewConfiguration.bottomInset = 66.0
        } else {
            tableViewConfiguration.bottomInset = 0.0
        }
        
        tableView.configure(with: .custom(tableViewConfiguration))
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.setupUI()
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
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
    
    @IBAction func requestsButtonAction(_ sender: UIButton) {
        viewModel.showRequests()
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

