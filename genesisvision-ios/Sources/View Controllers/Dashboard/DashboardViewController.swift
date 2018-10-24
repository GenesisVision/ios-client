//
//  DashboardViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: DashboardViewModel!
    
    // MARK: - Variables
    var dateRangeView: DateRangeView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var chartsView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var assetsView: UIView!
    
    var eventsViewHeightStart: CGFloat = 150.0
    var eventsViewHeightEnd: CGFloat = 220.0
    
    var chartsViewHeightStart: CGFloat = 400.0
    var chartsViewHeightEnd: CGFloat = 100.0
    
    private var notificationsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var chartsViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            chartsViewHeightConstraint.constant = chartsViewHeightStart
        }
    }
    @IBOutlet weak var eventsViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            eventsViewHeightConstraint.constant = eventsViewHeightEnd
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AssetsViewController,
            segue.identifier == "AssetsViewControllerSegue" {
            vc.viewModel = viewModel.assetsTabmanViewModel
            
            viewModel.router.dashboardAssetsViewController = vc
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
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupPullToRefresh(scrollView: scrollView)
        
        showProgressHUD()
        setupUI()
        fetch()
    }
    
    private func reloadData() {
        if let events = viewModel.dashboard?.events?.events, events.count > 0 {
            eventsView.isHidden = false
            eventsViewHeightConstraint.constant = eventsViewHeightEnd
        } else {
            eventsView.isHidden = true
            eventsViewHeightConstraint.constant = 0.0
        }
        
        if let balanceChart = viewModel.dashboard?.chart?.balanceChart, balanceChart.count > 0 {
            viewModel.router.chartsViewController?.hideChart(false)
            chartsViewHeightConstraint.constant = chartsViewHeightStart
        } else {
            viewModel.router.chartsViewController?.hideChart(true)
            chartsViewHeightConstraint.constant = 220.0
        }
        
        if let notificationsCount = viewModel.dashboard?.profileHeader?.notificationsCount {
            notificationsBarButtonItem = UIBarButtonItem(image: notificationsCount > 0 ? #imageLiteral(resourceName: "img_activeNotifications_icon") : #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
            navigationItem.leftBarButtonItems = [notificationsBarButtonItem]
        }
    }
    
    private func fetch() {
        viewModel.refresh { [weak self] (result) in
            DispatchQueue.main.async {
                self?.hideAll()
                self?.viewModel.isLoading = false
                
                switch result {
                case .success:
                    self?.reloadData()
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self)
                }
            }
        }
    }
    
    private func setupUI() {
        navigationTitleView = NavigationTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        bottomViewType = .none
        
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        navigationItem.leftBarButtonItems = [notificationsBarButtonItem]
        addCurrencyTitleButton(CurrencyDelegateManager())
        
        let dateRangeButton = UIButton(type: .system)
        dateRangeButton.setTitle("Week", for: .normal)
        dateRangeButton.semanticContentAttribute = .forceRightToLeft
        dateRangeButton.setImage(#imageLiteral(resourceName: "img_arrow_down_icon"), for: .normal)
        dateRangeButton.addTarget(self, action: #selector(dateRangeButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateRangeButton)
//        scrollView.bounces = false
    }
    
    // MARK: - Public methods
    override func dateRangeButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Date range")
        bottomSheetController.initializeHeight = 379
        
        dateRangeView = DateRangeView.viewFromNib()
        bottomSheetController.addContentsView(dateRangeView)
        dateRangeView.delegate = self
        bottomSheetController.present()
    }
    
    func showRequests(_ programRequests: ProgramRequests?) {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("In Requests")
        viewModel.inRequestsDelegateManager.programRequests = programRequests
        viewModel.inRequestsDelegateManager.inRequestsDelegate = self
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.registerNibs(for: viewModel.inRequestsDelegateManager.inRequestsCellModelsForRegistration)
            tableView.delegate = self?.viewModel.inRequestsDelegateManager
            tableView.dataSource = self?.viewModel.inRequestsDelegateManager
            tableView.separatorStyle = .none
        }
        
        bottomSheetController.present()
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotificationList()
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        navigationItem.leftBarButtonItems = [notificationsBarButtonItem]
    }
    
    // MARK: - Private methods
    private func animateChartsView(_ yOffset: CGFloat) {
        let chartsH = chartsViewHeightStart - yOffset * 2
        if chartsH >= chartsViewHeightEnd && chartsH <= chartsViewHeightStart {
            chartsViewHeightConstraint.constant = chartsH
            viewModel.router.chartsViewController?.viewDidLayoutSubviews()
        }
    }
    
    private func animateEventsView(_ yOffset: CGFloat) {
        let newHeight = eventsViewHeightStart + yOffset * 2
        if newHeight >= eventsViewHeightStart && newHeight <= eventsViewHeightEnd {
            eventsViewHeightConstraint.constant = newHeight
            viewModel.router.eventsViewController?.viewDidLayoutSubviews()
        }
    }
    
    private func animateViews(_ yOffset: CGFloat) {
        animateChartsView(yOffset)
        animateEventsView(yOffset)
    }
}

extension DashboardViewController: DateRangeViewProtocol {
    func applyButtonDidPress(with dateRangeType: DateRangeType, dateRangeFrom: Date, dateRangeTo: Date) {
        bottomSheetController.dismiss()
        
        viewModel.dateRangeFrom = dateRangeFrom
        viewModel.dateRangeTo = dateRangeTo
        viewModel.dateRangeType = dateRangeType
        fetch()
    }
    
    func showDatePicker(with dateRangeFrom: Date?, dateRangeTo: Date) {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
//        alert.view.tintColor = UIColor.primary
        
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

extension DashboardViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        navigationTitleView?.scrollViewDidScroll(scrollView, threshold: -30.0)
        
        let yOffset = scrollView.contentOffset.y
//        animateViews(yOffset)
        
        if !viewModel.isLoading && yOffset < -100 {
            showProgressHUD()
            fetch()
            return
        }
        
        if scrollView == self.scrollView {
            if let pageboyDataSource = viewModel.router.dashboardAssetsViewController?.pageboyDataSource {
                for controller in pageboyDataSource.controllers {
                    if let vc = controller as? BaseViewControllerWithTableView {
                        vc.tableView?.isScrollEnabled = yOffset >= assetsView.frame.origin.y
                    }
                }
            }
        }
    }
}

extension DashboardViewController: SortingDelegate {
    func didSelectSorting() {
        bottomSheetController.dismiss()
        fetch()
    }
}

extension DashboardViewController: InRequestsDelegateManagerProtocol {
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
