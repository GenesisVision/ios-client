//
//  DashboardViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {

    // MARK: - Variables
    var dateRangeView: DateRangeView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chartsView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var assetsView: UIView!
    
    var eventsViewHeightStart: CGFloat = 150.0
    var eventsViewHeightChange: CGFloat = 70.0
    
    var currencyBarButtonItem: UIBarButtonItem!
    var notificationsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var chartsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventsViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Model
    var viewModel: DashboardViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AssetsViewController,
            segue.identifier == "AssetsViewControllerSegue" {
            vc.viewModel = viewModel.assetsTabmanViewModel
            
            viewModel.router.assetsViewController = vc
        } else if let vc = segue.destination as? EventsViewController,
            segue.identifier == "EventsViewControllerSegue" {
            vc.viewModel = viewModel.eventListViewModel
            
            viewModel.router.eventsViewController = vc
        } else if let vc = segue.destination as? ChartsViewController,
            segue.identifier == "ChartsViewControllerSegue" {
            vc.viewModel = viewModel.chartsTabmanViewModel
            
            viewModel.router.chartsViewController = vc
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        scrollView.delegate = self
        
        showProgressHUD()
        fetch()

        setupUI()
    }
    private func reloadData() {
        
    }
    
    private func fetch() {
        viewModel.refresh { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.reloadData()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func setupUI() {
        let selectedCurrency = viewModel.currencyDelegateManager.selectedCurrency
        currencyBarButtonItem = UIBarButtonItem(title: selectedCurrency?.uppercased(), style: .done, target: self, action: #selector(currencyButtonAction))
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_program_read_more"), style: .done, target: self, action: #selector(notificationsButtonAction))
        
        navigationItem.leftBarButtonItems = [notificationsBarButtonItem, currencyBarButtonItem]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Week", style: .done, target: self, action: #selector(dateRangeButtonAction))
    }
    
    // MARK: - Public methods
    @objc func dateRangeButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Date range")
        bottomSheetController.initializeHeight = 379
        
        dateRangeView = DateRangeView.viewFromNib()
        bottomSheetController.addContentsView(dateRangeView)
        dateRangeView.delegate = self
        bottomSheetController.present()
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotificationList()
    }
    
    @objc func currencyButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("Preferred Currency")
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.registerNibs(for: viewModel.currencyCellModelsForRegistration)
            tableView.delegate = self?.viewModel.currencyDelegateManager
            tableView.dataSource = self?.viewModel.currencyDelegateManager
            tableView.separatorStyle = .none
        }
        
        viewModel.currencyDelegateManager.currencyDelegate = self
        bottomSheetController.present()
    }
    
    // MARK: - Private methods
}

extension DashboardViewController: DateRangeViewProtocol {
    func applyButtonDidPress(with dateRangeType: DateRangeType, dateRangeFrom: Date, dateRangeTo: Date) {
        viewModel.dateRangeFrom = dateRangeFrom
        viewModel.dateRangeTo = dateRangeTo
        viewModel.dateRangeType = dateRangeType
        //        fetch()
    }
    
    func showDatePicker(with dateRangeFrom: Date?, dateRangeTo: Date) {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.primary
        
        if let dateRangeFrom = dateRangeFrom {
            alert.addDatePicker(mode: .date, date: dateRangeFrom, minimumDate: nil, maximumDate: dateRangeTo.previousDate()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateRangeFrom = date
                }
            }
        } else {
            alert.addDatePicker(mode: .date, date: dateRangeTo, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateRangeTo = date
                }
            }
        }
        
        alert.addAction(title: "Done", style: .cancel)
        bottomSheetController.present(viewController: alert)
    }
}

//extension DashboardViewController: UIViewControllerPreviewingDelegate {
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
//                           viewControllerForLocation location: CGPoint) -> UIViewController? {
//
//        let cellPosition = tableView.convert(location, from: view)
//
//        guard let indexPath = tableView.indexPathForRow(at: cellPosition),
//            let vc = viewModel.getDetailsViewController(with: indexPath),
//            let cell = tableView.cellForRow(at: indexPath)
//            else { return nil }
//
//        vc.preferredContentSize = CGSize(width: 0.0, height: 500)
//        previewingContext.sourceRect = view.convert(cell.frame, from: tableView)
//
//        return vc
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        push(viewController: viewControllerToCommit)
//    }
//}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
        let yOffset = scrollView.contentOffset.y
        
        let newHeight = eventsViewHeightStart + yOffset * 2
        if newHeight >= eventsViewHeightStart && newHeight <= eventsViewHeightStart + eventsViewHeightChange {
            eventsViewHeightConstraint.constant = newHeight
            viewModel.router.eventsViewController?.viewDidLayoutSubviews()
        }
        
        let chartsH = 400.0 - 200.0 * yOffset / (400.0 - 200.0)
        if chartsH >= 400.0 - 200.0 && chartsH <= 400.0 {
            chartsViewHeightConstraint.constant = chartsH
            viewModel.router.chartsViewController?.viewDidLayoutSubviews()
        }
        
        if scrollView == self.scrollView {
            if yOffset == assetsView.frame.origin.y {
                if let pageboyDataSource = viewModel.router.assetsViewController?.pageboyDataSource,
                    let controllers = pageboyDataSource.controllers {
                    for controller in controllers {
                        if let vc = controller as? BaseViewControllerWithTableView {
                            vc.tableView?.isScrollEnabled = true
                        }
                    }
                }
            }
        }
    }
}

extension DashboardViewController: SortingDelegate {
    func didSelectSorting(at indexPath: IndexPath) {
        bottomSheetController.dismiss()
    }
}

extension DashboardViewController: CurrencyDelegate {
    func didSelectCurrency(at indexPath: IndexPath) {
        if let selectedCurrency = viewModel.currencyDelegateManager.selectedCurrency {
            currencyBarButtonItem = UIBarButtonItem(title: selectedCurrency.uppercased(), style: .done, target: self, action: #selector(currencyButtonAction))
            navigationItem.leftBarButtonItems = [notificationsBarButtonItem, currencyBarButtonItem]
        }
        
        bottomSheetController.dismiss()
    }
}
