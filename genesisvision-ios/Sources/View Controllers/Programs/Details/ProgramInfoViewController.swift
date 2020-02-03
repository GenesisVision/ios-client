
//
//  ProgramInfoViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProgramInfoViewController: ListViewController {
    
    // MARK: - View Model
    var viewModel: ProgramInfoViewModel!
    
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
    func updateDetails(with programDetailsFull: ProgramFollowDetailsFull) {
        viewModel.updateDetails(with: programDetailsFull)
        didReload()
    }
    
    func showRequests(_ requests: ItemsViewModelAssetInvestmentRequest?) {
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

extension ProgramInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        didReload()
    }
}
extension ProgramInfoViewController: BaseTableViewProtocol {
    
}
extension ProgramInfoViewController: InRequestsDelegateManagerProtocol {
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

// MARK: - AboutLevelViewProtocol
extension ProgramInfoViewController: AboutLevelViewProtocol {
    func aboutLevelsButtonDidPress() {
        bottomSheetController.dismiss()
        
        viewModel.showAboutLevels()
    }
}

extension ProgramInfoViewController: ProgramHeaderProtocol {
    func aboutLevelButtonDidPress() {
        let aboutLevelView = AboutLevelView.viewFromNib()
        aboutLevelView.delegate = self
        
        if let programDetails = viewModel.programFollowDetailsFull, let currency = programDetails.tradingAccountInfo?.currency, let selectedCurrency = CurrencyType(rawValue: currency.rawValue) {
            aboutLevelView.configure(programDetails.programDetails?.level, currency: selectedCurrency)
        }
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.initializeHeight = 270
        bottomSheetController.addContentsView(aboutLevelView)
        bottomSheetController.present()
    }
}
