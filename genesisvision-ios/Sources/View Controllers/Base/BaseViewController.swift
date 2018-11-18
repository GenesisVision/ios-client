//
//  BaseViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MessageUI

class BaseViewController: UIViewController, Hidable, UIViewControllerWithBottomSheet, NodataProtocol {
    var noDataTitle: String? = nil
    var noDataImage: UIImage? = nil
    var noDataButtonTitle: String? = nil
    var dateRangeView: DateRangeView!
    
    // MARK: - Veriables
    var bottomSheetController: BottomSheetController! = {
        return BottomSheetController()
    }()
    
    var currencyDelegateManager: CurrencyDelegateManager?
    
    var refreshControl: UIRefreshControl?
    
    var navigationTitleView: NavigationTitleView?
    
    var sortButton: ActionButton = {
        let btn = ActionButton(type: .system)
        btn.configure(with: .filter(image: nil))
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.setTitle("Sort by profit", for: .normal)
        btn.addTarget(self, action: #selector(sortButtonAction), for: .touchUpInside)
        return btn
    }()
    
    var dateRangeButton: ActionButton = {
        let btn = ActionButton(type: .system)
        btn.configure(with: .filter(image: #imageLiteral(resourceName: "img_date_range_icon")))
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.setTitle("Date range", for: .normal)
        btn.addTarget(self, action: #selector(dateRangeButtonAction), for: .touchUpInside)
        return btn
    }()
    
    var filterButton: ActionButton = {
        let btn = ActionButton(type: .system)
        btn.configure(with: .filter(image: #imageLiteral(resourceName: "img_profit_filter_icon")))
        btn.setTitle("Filters", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        return btn
    }()
    
    var signInButton: ActionButton = {
        let btn = ActionButton(type: .system)
        btn.configure(with: .normal)
        btn.setTitle("Sign in", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return btn
    }()
    
    let filterStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 0.0
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var bottomStackViewHiddable: Bool = true
    
    var bottomViewType: BottomViewType = .none {
        didSet {
            sortButton.isHidden = true
            filterButton.isHidden = true
            signInButton.isHidden = true
            dateRangeButton.isHidden = true
            bottomStackView.isHidden = false
            
            switch bottomViewType {
            case .none:
                bottomStackView.isHidden = true
            case .sort:
                sortButton.isHidden = false
            case .filter:
                filterButton.isHidden = false
            case .dateRange:
                dateRangeButton.isHidden = false
            case .signIn:
                signInButton.isHidden = false
            case .signInWithFilter:
                signInButton.isHidden = false
                filterButton.isHidden = false
            case .signInWithDateRange:
                signInButton.isHidden = false
                dateRangeButton.isHidden = false
            }
        }
    }
    
    var prefersLargeTitles: Bool = true {
        didSet {
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
            }
        }
    }
    
    public private(set) var lastContentOffset: CGPoint = .zero
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dateRangeView = DateRangeView.viewFromNib()

        updateDateRangeButton()
        correctTime()
        
        commonSetup()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCurrencyButtonTitle()
    }
    
    // MARK: - Public Methods
    func updateData(from dateFrom: Date?, to dateTo: Date?) {
        //fetch()
    }
    
    func addCurrencyTitleButton(_ currencyDelegateManager: CurrencyDelegateManager?) {
        navigationTitleView?.currencyTitleButton.addTarget(target, action: action, for: .touchUpInside)
        self.currencyDelegateManager = currencyDelegateManager
        currencyDelegateManager?.currencyDelegate = self
        
        navigationItem.titleView = navigationTitleView
    }
    
    func updateCurrencyButtonTitle() {
        let selectedCurrency = getSelectedCurrency()
        navigationTitleView?.currencyTitleButton.setTitle(selectedCurrency, for: .normal)
        navigationTitleView?.currencyTitleButton.sizeToFit()
    }
    
    @objc func dateRangeButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Date range")
        bottomSheetController.initializeHeight = 370
        bottomSheetController.addContentsView(dateRangeView)
        bottomSheetController.bottomSheetControllerProtocol = dateRangeView
        dateRangeView.delegate = self
        bottomSheetController.present()
    }
    
    // MARK: - Private Methods
    internal func setupAutoLayout() {
        sortButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        dateRangeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dateRangeButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        filterButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInButton.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor).isActive = true
        
        filterStackView.leftAnchor.constraint(equalTo: bottomStackView.leftAnchor, constant: 0).isActive = true
        filterStackView.rightAnchor.constraint(equalTo: bottomStackView.rightAnchor, constant: 0).isActive = true
        filterStackView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        bottomStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bottomStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        if #available(iOS 11, *) {
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        }
    }
    
    internal func addBottomView() {
        filterStackView.addArrangedSubview(sortButton)
        filterStackView.addArrangedSubview(filterButton)
        filterStackView.addArrangedSubview(dateRangeButton)
        bottomStackView.addArrangedSubview(filterStackView)
        bottomStackView.addArrangedSubview(signInButton)
        view.addSubview(bottomStackView)
        
        bottomViewType = .none
        
        setupAutoLayout()
    }
    
    @objc private func currencyButtonAction() {
        currencyDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 250.0
        
        bottomSheetController.addNavigationBar("Preferred currency")
        
        bottomSheetController.addTableView { [weak self] tableView in
            currencyDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let currencyDelegateManager = self?.currencyDelegateManager else { return }
            currencyDelegateManager.loadCurrencies()
            tableView.registerNibs(for: currencyDelegateManager.cellModelsForRegistration)
            tableView.delegate = currencyDelegateManager
            tableView.dataSource = currencyDelegateManager
        }
        
        bottomSheetController.present()
    }
    
    func showBottomSheet(type: ErrorBottomSheetViewType, title: String? = nil, subtitle: String? = nil, initializeHeight: CGFloat? = 300.0, completion: SuccessCompletionBlock? = nil) {
        let errorBottomSheetView = ErrorBottomSheetView.viewFromNib()
        errorBottomSheetView.configure(type: type, title: title, subtitle: subtitle, completion: completion)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.viewType = .bottomView
        bottomSheetController.bottomSheetControllerProtocol = errorBottomSheetView
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.initializeHeight = initializeHeight ?? 300.0
        bottomSheetController.viewActionType = .tappedDismiss
        bottomSheetController.addContentsView(errorBottomSheetView)
        errorBottomSheetView.bottomSheetController = self.bottomSheetController
        
        bottomSheetController.present()
    }
    
    func hideAll() {
        hideHUD()
        refreshControl?.endRefreshing()
    }
    
    private func correctTime() {
        let dateRangeType = PlatformManager.shared.dateRangeType
        
        guard var dateFrom = PlatformManager.shared.dateFrom, var dateTo = PlatformManager.shared.dateTo else {
            updateData(from: nil, to: nil)
            return
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        switch dateRangeType {
        case .custom:
            dateFrom.setTime(hour: 0, min: 0, sec: 0)
            dateTo.setTime(hour: 0, min: 0, sec: 0)
            
            let hour = calendar.component(.hour, from: dateTo)
            let min = calendar.component(.minute, from: dateTo)
            let sec = calendar.component(.second, from: dateTo)
            dateFrom.setTime(hour: hour, min: min, sec: sec)
            dateTo.setTime(hour: hour, min: min, sec: sec)
            dateFrom = dateFrom.removeDays(1)
        default:
            let hour = calendar.component(.hour, from: dateTo)
            let min = calendar.component(.minute, from: dateTo)
            let sec = calendar.component(.second, from: dateTo)
            dateFrom.setTime(hour: hour, min: min, sec: sec)
            dateTo.setTime(hour: hour, min: min, sec: sec)
        }
        
        updateData(from: dateFrom, to: dateTo)
    }
}

extension BaseViewController: UIViewControllerWithPullToRefresh {
    @objc func pullToRefresh() {
        impactFeedback()
    }
    
    func setupPullToRefresh(title: String? = nil, scrollView: UIScrollView) {
        let tintColor = UIColor.primary
        let attributes = [NSAttributedStringKey.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        if let title = title {
            refreshControl?.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        }
        refreshControl?.tintColor = tintColor
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
}

extension BaseViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard bottomStackViewHiddable else { return }
        
        self.lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard bottomStackViewHiddable else { return }
        
        if self.lastContentOffset.y < scrollView.contentOffset.y && self.filterStackView.alpha == 1.0 {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.filterStackView.alpha = 0.0
            }) { (success) in
                self.filterStackView.isHidden = true
            }
        } else if self.lastContentOffset.y > scrollView.contentOffset.y && self.filterStackView.alpha == 0.0 {
            self.filterStackView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.filterStackView.alpha = 1.0
            })
        }
    }
}

extension BaseViewController: DateRangeViewProtocol {
    func applyButtonDidPress(from dateFrom: Date?, to dateTo: Date?) {
        bottomSheetController.dismiss()

        updateDateRangeButton()
        correctTime()
    }
    
    private func updateDateRangeButton() {
        let dateRangeType = PlatformManager.shared.dateRangeType
        
        switch dateRangeType {
        case .custom:
            guard let dateFrom = PlatformManager.shared.dateFrom, let dateTo = PlatformManager.shared.dateTo else { return }
            
            let title = Date.getFormatStringForChart(for: dateFrom, dateRangeType: dateRangeType) + "-" + Date.getFormatStringForChart(for: dateTo, dateRangeType: dateRangeType)
            dateRangeButton.setTitle(title, for: .normal)
        default:
            dateRangeButton.setTitle(dateRangeType.getString(), for: .normal)
        }
    }
    
    func showDatePicker(from dateFrom: Date?, to dateTo: Date) {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.Cell.headerBg
        
        if let dateFrom = dateFrom {
            alert.addDatePicker(mode: .date, date: dateFrom, minimumDate: nil, maximumDate: dateTo.previousDate()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateFrom = date
                }
            }
        } else {
            alert.addDatePicker(mode: .date, date: dateTo, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateTo = date
                }
            }
        }
        
        alert.addAction(title: "Done", style: .cancel)
        bottomSheetController.present(viewController: alert)
    }
}

extension BaseViewController: CurrencyDelegateManagerProtocol {
    func didSelectCurrency(at indexPath: IndexPath) {
        updateCurrencyButtonTitle()
        pullToRefresh()
        
        bottomSheetController.dismiss()
    }
}

extension BaseViewController: CurrencyTitleButtonProtocol {
    var target: Any? {
        return self
    }
    
    var action: Selector! {
        return #selector(currencyButtonAction)
    }
}

extension BaseViewController: UIViewControllerWithBottomView {
    @objc func signInButtonAction() {
        
    }
    
    @objc func filterButtonAction() {
        
    }
    
    @objc func sortButtonAction() {
        
    }
}

extension UIViewController {
    func updateTheme() {
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.BaseView.bg
        }

        setupNavigationBar()
        AppearanceController.applyTheme()
    }
    
    func commonSetup() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    }
    
    // MARK: - Public methods
    func setupNavigationBar(with type: NavBarType = .gray) {
        AppearanceController.setupNavigationBar(with: type)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    func sendEmailFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController()
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let colors = UIColor.NavBar.colorScheme()
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([Urls.feedbackEmailAddress])
        mailComposerVC.setSubject(getFeedbackSubject())
        mailComposerVC.setMessageBody(getDeviceInfo(), isHTML: false)
        mailComposerVC.navigationBar.isTranslucent = false
        mailComposerVC.navigationBar.barTintColor = colors.backgroundColor
        mailComposerVC.navigationBar.tintColor = colors.tintColor
        mailComposerVC.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.textColor,
                                                            NSAttributedStringKey.font: UIFont.getFont(.bold, size: 18)]
        return mailComposerVC
    }
    
    private func showSendMailErrorAlert() {
        showAlertWithTitle(title: String.Alerts.ErrorMessages.MailErrorAlert.title,
                           message: String.Alerts.ErrorMessages.MailErrorAlert.message,
                           actionTitle: nil,
                           cancelTitle: String.Alerts.ErrorMessages.MailErrorAlert.cancelButtonText,
                           handler: nil,
                           cancelHandler: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

