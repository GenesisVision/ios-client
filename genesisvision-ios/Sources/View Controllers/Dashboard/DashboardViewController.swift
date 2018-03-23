//
//  DashboardViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DashboardViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: DashboardViewModel!

    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        registerForPreviewing()
        
        showProgressHUD()
        fetch()
        setupUI()
    }
    
    private func setupUI() {
        title = viewModel.title.uppercased()
        navigationItem.title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: DashboardViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: InvestmentProgramListViewModel.viewModelsForRegistration)
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 100, height: 100)
        tableView.layer.shadowRadius = 5.0
        tableView.layer.shadowOpacity = 0.5
        tableView.clipsToBounds = true
        tableView.layer.masksToBounds = true

        
        setupPullToRefresh()
    }
    
    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    private func updateSortHeaderView() {
        guard let title = self.viewModel.headerTitle(for: 1) else {
            return
        }
        
        let header = self.tableView.headerView(forSection: 1) as! SortHeaderView
        header.sortButton.setTitle(title, for: .normal)
        
        showProgressHUD()
        fetch()
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideHUD()
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    override func fetchMore() {
        canFetchMoreResults = false
        self.viewModel.fetchMore { [weak self] (result) in
            self?.canFetchMoreResults = true
            switch result {
            case .success:
                self?.reloadData()
            case .failure:
                break
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.modelsCount() >= indexPath.row else {
            return
        }
        
        viewModel.showDetail(at: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section > 0, indexPath.row > 0 { cell.addDashedBottomLine() }
        
        if (viewModel.modelsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView() as SortHeaderView
        header.sortButton.setTitle(title, for: .normal)
        header.delegate = self
        
        return header
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}

extension DashboardViewController {
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = viewModel.noDataText()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 25)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let imageName = viewModel.noDataImageName() {
            return UIImage(named: imageName)
        }
        
        return UIImage.placeholder
    }
    
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showProgramList()
    }
    
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = viewModel.noDataButtonTitle()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.primary]

        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension DashboardViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailViewController(with: indexPath),
            let cell = tableView.cellForRow(at: indexPath)
            else { return nil }
        
        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
        previewingContext.sourceRect = view.convert(cell.frame, from: tableView)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        push(viewController: viewControllerToCommit)
    }
}

extension DashboardViewController: SortHeaderViewProtocol {
    func sortButtonDidPress() {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        
        var selectedIndexRow = viewModel.getSelectedSortingIndex()
        let values = viewModel.sortingValues
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
        
        let applyAction = UIAlertAction(title: "Apply", style: .default) { [weak self] (action) in
            guard selectedIndexRow != self?.viewModel.getSelectedSortingIndex() else { return }
            
            self?.viewModel.changeSorting(at: selectedIndexRow)
            self?.updateSortHeaderView()
        }
        
        applyAction.isEnabled = false
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            
            guard index.row != self?.viewModel.getSelectedSortingIndex() else {
                return applyAction.isEnabled = false
            }
            
            applyAction.isEnabled = true
            selectedIndexRow = index.row
        }
        
        alert.addAction(applyAction)
        
        alert.addAction(title: "Cancel", style: .cancel)
        
        alert.show()
    }
}

extension DashboardViewController: ReloadDataProtocol {
    func didReloadData() {
        reloadData()
    }
}

