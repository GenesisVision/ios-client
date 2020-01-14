
//
//  AccountInfoViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.2020.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class AccountInfoViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: AccountInfoViewModel!
    
    // MARK: - Views
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        showProgressHUD()
        fetch()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        showInfiniteIndicator(value: false)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let errorType):
                self?.reloadData()
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}

extension AccountInfoViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath) else {
            return TableViewCell()
        }

        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel?.didSelectRow(at: indexPath)
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
        let view = UIView()
        view.backgroundColor = UIColor.Cell.headerBg
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), indexPath.section == 0, indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
            cell.accessoryView?.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.BaseView.bg
            cell.accessoryView?.backgroundColor = UIColor.BaseView.bg
        }
    }
}

extension AccountInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

class OldDetailInfoViewController<ViewModel: ViewModelWithListProtocol>: ListViewController {
    // MARK: - Veriables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetch()
    }
    private func setup() {
        setupPullToRefresh(scrollView: tableView)
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch()
    }
    
    func fetch() {
        reloadData()
    }
}
extension OldDetailInfoViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("select cell \(type)")
        
    }
    
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
    }
    
    func didReload(_ indexPath: IndexPath) {
        hideHUD()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
