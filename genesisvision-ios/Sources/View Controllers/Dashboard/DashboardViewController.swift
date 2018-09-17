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
    var eventsViewHeightChange: CGFloat = 120.0
    
    var chartsViewController: ChartsViewController?
    var eventsViewController: EventsViewController?
    var assetsViewController: AssetsViewController?
    
    @IBOutlet weak var chartsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventsViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Model
    var viewModel: DashboardViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showProgressHUD()
        setup()
        
//        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AssetsViewController,
            segue.identifier == "AssetsViewControllerSegue" {
            let viewModel = AssetsTabmanViewModel(withRouter: Router(parentRouter: nil), tabmanViewModelDelegate: nil)
            vc.viewModel = viewModel
            
            assetsViewController = vc
        } else if let vc = segue.destination as? EventsViewController,
            segue.identifier == "EventsViewControllerSegue" {
            eventsViewController = vc
        } else if let vc = segue.destination as? ChartsViewController,
            segue.identifier == "ChartsViewControllerSegue" {
            
            let viewModel = ChartsTabmanViewModel(withRouter: Router(parentRouter: nil), tabmanViewModelDelegate: nil)
            vc.viewModel = viewModel
            
            chartsViewController = vc
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        scrollView.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        let currencyBarButtonItem = UIBarButtonItem(title: "BTC", style: .done, target: self, action: #selector(currencyButtonAction))
        let notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_program_read_more"), style: .done, target: self, action: #selector(notificationsButtonAction))
        
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
            if let currencyCellModelsForRegistration = self?.viewModel.currencyCellModelsForRegistration {
                tableView.registerNibs(for: currencyCellModelsForRegistration)
            }
            tableView.delegate = self?.viewModel.currencyDelegateManager
            tableView.dataSource = self?.viewModel.currencyDelegateManager
            tableView.separatorStyle = .none
        }
        
        viewModel.currencyDelegateManager.tableViewProtocol = self
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

//extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
//
//    // MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        guard viewModel.modelsCount() >= indexPath.row else {
//            return
//        }
//
//        viewModel.showDetail(at: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let model = viewModel.model(at: indexPath) else {
//            return UITableViewCell()
//        }
//
//        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        showInfiniteIndicator(value: viewModel.fetchMore(at: indexPath.row))
//
////        if let cell = cell as? DashboardTableViewCell {
////            cell.startTimer()
////        }
//    }
//
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        if let cell = cell as? DashboardTableViewCell {
////            cell.stopTimer()
////        }
//    }
//
//    // MARK: - UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRows(in: section)
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.numberOfSections()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return viewModel.headerHeight(for: section)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return viewModel.heightForRow(at: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard section != 1 else {
//            return nil
//        }
//
//        let header = tableView.dequeueReusableHeaderFooterView() as SegmentedHeaderFooterView
//        header.configure(with: viewModel.headerSegments(for: section))
//
//        return header
//    }
//}

//extension DashboardViewController {
//    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = viewModel.noDataText()
//        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
//                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 25)]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//
//    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        if let imageName = viewModel.noDataImageName() {
//            return UIImage(named: imageName)
//        }
//
//        return UIImage.noDataPlaceholder
//    }
//
//    override func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//        viewModel.showProgramList()
//    }
//
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        let text = viewModel.noDataButtonTitle()
//        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.white,
//                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 14)]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//}

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

//extension DashboardViewController: ProgramDetailViewControllerProtocol {
//    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool) {
//        showProgressHUD()
//        viewModel.changeFavorite(value: value, investmentProgramId: programID, request: request) { [weak self] (result) in
//            self?.hideAll()
//        }
//    }
//}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
        let yOffset = scrollView.contentOffset.y
        
        let h = eventsViewHeightStart + eventsViewHeightChange * yOffset / (eventsViewHeightStart + eventsViewHeightChange)
        if h <= eventsViewHeightStart + eventsViewHeightChange && h >= eventsViewHeightStart {
            eventsViewHeightConstraint.constant = eventsViewHeightStart + eventsViewHeightChange * yOffset / (eventsViewHeightStart + eventsViewHeightChange)
            eventsViewController?.viewDidLayoutSubviews()
        }
        
        let chartsH = 350.0 - 200.0 * yOffset / (350.0 - 200.0)
        if chartsH <= 350.0 && h >= 350.0 - 200.0 {
            chartsViewHeightConstraint.constant = 350.0 - 200.0 * yOffset / (350.0 - 200.0)
            chartsViewController?.viewDidLayoutSubviews()
        }
        
        if scrollView == self.scrollView {
            if yOffset == assetsView.frame.origin.y {
                if let pageboyDataSource = assetsViewController?.pageboyDataSource,
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
        bottomSheetController.dismiss()
    }
}
