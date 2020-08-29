
//
//  FundInfoViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class FundInfoViewController: ListViewController {
    
    // MARK: - View Model
    var viewModel: FundInfoViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        showProgressHUD()
        fetch()
    }
    
    // MARK: - Private methods
    private func setup() {
        tableView.configure(with: .defaultConfiguration)

        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    // MARK: - Public methods
    func updateDetails(with fundDetailsFull: FundDetailsFull) {
        viewModel.updateDetails(with: fundDetailsFull)
        didReload()
    }
    
    func updateDetails() {
        fetch()
    }
    
    func showRequests(_ requests: AssetInvestmentRequestItemsViewModel?) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("In requests")
        viewModel.inRequestsDelegateManager.inRequestsDelegate = self
        viewModel.inRequestsDelegateManager.requestSelectable = false
        viewModel.inRequestsDelegateManager.requests = requests
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.registerNibs(for: viewModel.inRequestsDelegateManager.inRequestsCellModelsForRegistration)
            tableView.delegate = self?.viewModel.inRequestsDelegateManager
            tableView.dataSource = self?.viewModel.inRequestsDelegateManager
            tableView.separatorStyle = .none
        }
        
        bottomSheetController.present()
    }
    
    func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            self?.didReload()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}
extension FundInfoViewController: BaseTableViewProtocol {
    
}
extension FundInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        didReload()
    }
}

extension FundInfoViewController: InRequestsDelegateManagerProtocol {
    func didSelectRequest(at indexPath: IndexPath) {
        
    }
    
    func didCanceledRequest(completionResult: CompletionResult) {
        bottomSheetController.dismiss()
        
        switch completionResult {
        case .success:
            fetch()
        default:
            break
        }
    }
}
