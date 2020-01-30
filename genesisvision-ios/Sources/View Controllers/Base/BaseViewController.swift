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

class BaseModalViewController: BaseViewController {
    private var closeButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
    }
    
    private func close() {
        showAlertWithTitle(.actionSheet, title: nil, message: "Are you sure?", actionTitle: "Close", cancelTitle: "Cancel", handler: {
            self.dismiss(animated: true, completion: nil)
        }, cancelHandler: nil)
    }
    
    func addCloseButton() {
        closeButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_close_icon"), style: .done, target: self, action: #selector(closeButtonAction))
        navigationItem.leftBarButtonItems = [closeButtonItem]
    }
    
    @objc private func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension BaseModalViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        close()
    }
}

class BaseViewController: UIViewController, Hidable, UIViewControllerWithBottomSheet, NodataProtocol {
    var noDataTitle: String? = nil
    var noDataImage: UIImage? = nil
    var noDataButtonTitle: String? = nil
    var dateRangeView: DateRangeView!
    var dateRangeModel: FilterDateRangeModel = FilterDateRangeModel()
    
    // MARK: - Veriables
    lazy var bottomSheetController: BottomSheetController = {
        return BottomSheetController()
    }()
    
    var refreshControl: UIRefreshControl?
    
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
        
        view.backgroundColor = UIColor.BaseView.bg
    }
    
    // MARK: - Public Methods
    func scrollToTop(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    func updateData(from dateFrom: Date?, to dateTo: Date?) {
        //fetch()
    }
    
    @objc func dateRangeButtonAction() {
        dateRangeView.delegate = self
//        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Date range")
        bottomSheetController.initializeHeight = 370
        bottomSheetController.addContentsView(dateRangeView)
        bottomSheetController.bottomSheetControllerProtocol = dateRangeView
        bottomSheetController.present()
    }
    
    // MARK: - Private Methods
    internal func setupAutoLayout() {
        sortButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        dateRangeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dateRangeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
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
    
    func showBottomSheet(_ type: ErrorBottomSheetViewType, title: String? = nil, subtitle: String? = nil, initializeHeight: CGFloat? = 300.0, completion: SuccessCompletionBlock? = nil) {
        let errorBottomSheetView = ErrorBottomSheetView.viewFromNib()
        errorBottomSheetView.configure(type, title: title, subtitle: subtitle, completion: completion)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.viewType = .bottomView
        bottomSheetController.bottomSheetControllerProtocol = errorBottomSheetView
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.initializeHeight = initializeHeight ?? 300.0
        bottomSheetController.viewActionType = .tappedDismiss
        bottomSheetController.addContentsView(errorBottomSheetView)
        errorBottomSheetView.bottomSheetController = self.bottomSheetController
        
        self.present(viewController: bottomSheetController)
    }
    
    func hideAll() {
        hideHUD()
        refreshControl?.endRefreshing()
    }
    
    private func correctTime() {
        let dateRangeType = dateRangeModel.dateRangeType
        
        guard var dateFrom = dateRangeModel.dateFrom, var dateTo = dateRangeModel.dateTo else {
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
        let attributes = [NSAttributedString.Key.foregroundColor : tintColor]
        
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
    var dateRange: FilterDateRangeModel? {
        get {
            return dateRangeModel
        }
        set {
            if let newValue = newValue {
                dateRangeModel = newValue
            }
        }
    }
    
    func applyButtonDidPress(from dateFrom: Date?, to dateTo: Date?) {
        bottomSheetController.dismiss()

        updateDateRangeButton()
        correctTime()
    }
    
    private func updateDateRangeButton() {
        let dateRangeType = dateRangeModel.dateRangeType
        
        switch dateRangeType {
        case .custom:
            guard let dateFrom = dateRangeModel.dateFrom, let dateTo = dateRangeModel.dateTo else { return }
            
            let title = Date.getFormatStringForChart(for: dateFrom, dateRangeType: dateRangeType) + "-" + Date.getFormatStringForChart(for: dateTo, dateRangeType: dateRangeType)
            dateRangeButton.setTitle(title, for: .normal)
        default:
            dateRangeButton.setTitle(dateRangeType.getString(), for: .normal)
        }
    }
    
    func showDatePicker(from dateFrom: Date, to dateTo: Date, isFrom: Bool) {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        
        if isFrom {
            alert.addDatePicker(mode: .date, date: dateFrom, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateFrom = date
                    self?.dateRangeView.dateTo = dateTo.compare(date) == .orderedAscending ? date : dateTo
                }
            }
        } else {
            alert.addDatePicker(mode: .date, date: dateTo, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView.dateFrom = dateFrom.compare(date) == .orderedDescending ? date : dateFrom
                    self?.dateRangeView.dateTo = date
                }
            }
        }
        
        alert.addAction(title: "Done", style: .cancel)
        bottomSheetController.present(viewController: alert)
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
        mailComposerVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colors.textColor,
                                                            NSAttributedString.Key.font: UIFont.getFont(.bold, size: 18)]
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

