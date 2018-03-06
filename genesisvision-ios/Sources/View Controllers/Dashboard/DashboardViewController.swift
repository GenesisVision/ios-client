//
//  DashboardViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ViewAnimator

class DashboardViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: DashboardViewModel!

    // MARK: - Variables
    private let tableViewAnimation = AnimationType.from(direction: .right, offset: 30.0)

    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        
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
        title = viewModel.title
    }
    
    private func setupTableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: DashboardViewModel.cellModelsForRegistration)
        
        setupPullToRefresh()
    }
    
    private func reloadData() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
        tableView.animateViews(animations: [tableViewAnimation])
    }
    
    private func fetch() {
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
        
        guard let investmentProgram = viewModel.model(for: indexPath.row)?.investmentProgram else {
            return
        }
        
        viewModel.showDetail(with: investmentProgram.id?.uuidString ?? "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (viewModel.modelsCount() - indexPath.row) == Constants.Api.fetchThreshold && canFetchMoreResults {
            fetchMore()
        }
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
}

extension DashboardViewController {
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = viewModel.noDataText()
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.systemFont(ofSize: 25, weight: .bold)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.showProgramList()
    }
    
    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Start investing!"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.primary]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension DashboardViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cellPosition = tableView.convert(location, from: view)
        
        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
            let vc = viewModel.getDetailViewController(with: indexPath.row),
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

extension DashboardViewController: DashboardTableViewCellProtocol {
    func investProgramDidPress(with investmentProgramId: String) {
        viewModel.invest(with: investmentProgramId)
    }
    
    func withdrawProgramDidPress(with investmentProgramId: String) {
        viewModel.withdraw(with: investmentProgramId)
    }
}
