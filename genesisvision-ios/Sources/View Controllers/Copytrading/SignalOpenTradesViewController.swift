//
//  SignalOpenTradesViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class SignalOpenTradesViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: SignalTradesViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    
    // MARK: - Private methods
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
//        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.bounces = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    private func setup() {
        bottomViewType = .none
        noDataTitle = viewModel.noDataText()
        setupTableConfiguration()
        
        setupNavigationBar()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    private func openDetails(_ details: OrderModel) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 450
        bottomSheetController.lineViewIsHidden = true
        
        let view = TradeDetailView.viewFromNib()
//        view.configure(details, uuid: <#UUID#>)
//        view.delegate = self
        bottomSheetController.addContentsView(view)
        bottomSheetController.present()
    }
    
    override func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            
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
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?) {
        viewModel.dateFrom = dateFrom
        viewModel.dateTo = dateTo
        
        showProgressHUD()
        fetch()
    }
    
}

extension SignalOpenTradesViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(for: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        scrollView.isScrollEnabled = scrollView.contentOffset.y > -44.0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDragging(scrollView)
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            scrollView.isScrollEnabled = scrollView.contentOffset.y > -44.0
        } else {
            scrollView.isScrollEnabled = scrollView.contentOffset.y >= -44.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel?.numberOfRows(in: section) ?? 0
        tableView.isScrollEnabled = numberOfRows > 0
        return numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView() as DateSectionTableHeaderView
        header.headerLabel.text = viewModel.titleForHeader(in: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard cellAnimations, let cell = tableView.cellForRow(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            cell.alpha = 0.8
            cell.transform = cell.transform.scaledBy(x: 0.96, y: 0.96)
        }, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard cellAnimations, let cell = tableView.cellForRow(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            cell.alpha = 1
            cell.transform = .identity
        }, completion: nil)
    }
}

extension SignalOpenTradesViewController: ReloadDataProtocol {
    func didReloadData() {
        hideAll()
        reloadData()
    }
}

extension SignalOpenTradesViewController: SignalTradesProtocol {
    func didCloseTrade(_ tradeId: String) {
        showAlertWithTitle(title: String.Alerts.SignalTrade.Close.title,
                           message: String.Alerts.SignalTrade.Close.message,
                           actionTitle: String.Alerts.okButtonText,
                           cancelTitle: String.Alerts.cancelButtonText,
                           handler: { [weak self] in
                            self?.showProgressHUD()
                            self?.viewModel.close(tradeId)
        }, cancelHandler: nil)
    }
}
