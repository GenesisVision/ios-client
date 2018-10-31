//
//  ManagerInfoViewController.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ManagerInfoViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: ManagerInfoViewModel!
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupNavigationBar()
        setupTableConfiguration()
        setupUI()
    }
    
    private func setupUI() {
        showInfiniteIndicator(value: false)
    }
    
    private func setupTableConfiguration() {
        tableView.isScrollEnabled = false
        tableView.configure(with: .defaultConfiguration)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Public methods
    func updateDetails(with managerProfileDetails: ManagerProfileDetails) {
        viewModel.updateDetails(with: managerProfileDetails)
        reloadData()
    }
}

extension ManagerInfoViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return TableViewCell()
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.Cell.headerBg
        return view
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = scrollView.contentOffset.y > -40.0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            scrollView.isScrollEnabled = scrollView.contentOffset.y > -40.0
        } else {
            scrollView.isScrollEnabled = scrollView.contentOffset.y >= -40.0
        }
    }
}

extension ManagerInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}
