
//
//  ProgramInfoViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProgramInfoViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: ProgramInfoViewModel!
    
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
            self.tableView?.reloadDataSmoothly()
        }
    }
    
    // MARK: - Public methods
    func updateDetails(with programDetailsFull: ProgramFollowDetailsFull) {
        viewModel.updateDetails(with: programDetailsFull)
        reloadData()
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

extension ProgramInfoViewController: UITableViewDelegate, UITableViewDataSource {
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

extension ProgramInfoViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

extension ProgramInfoViewController: InRequestsDelegateManagerProtocol {
    func didSelectRequest(at indexPath: IndexPath) {
        //FIXIT:
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
