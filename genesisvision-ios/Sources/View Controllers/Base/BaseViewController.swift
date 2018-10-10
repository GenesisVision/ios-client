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

class BaseViewController: UIViewController, Hidable {
    // MARK: - Veriables
    var bottomSheetController = BottomSheetController()
    var currencyDelegateManager: CurrencyDelegateManager?
    
    var refreshControl: UIRefreshControl?
    
    var currencyTitleButton: StatusButton = {
        let selectedCurrency = getSelectedCurrency()
        
        let currencyTitleButton = StatusButton(type: .system)
        currencyTitleButton.setTitle(selectedCurrency, for: .normal)
        currencyTitleButton.setTitleColor(UIColor.Cell.title, for: .normal)
        currencyTitleButton.bgColor = UIColor.Cell.bg
        currencyTitleButton.contentEdge = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        
        currencyTitleButton.sizeToFit()
        
        return currencyTitleButton
    }()
    
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
        btn.setTitle("SIGN IN", for: .normal)
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
    
    private var lastContentOffset: CGPoint = .zero
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        commonSetup()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTheme()
    }
    
    // MARK: - Public Methods
    func addCurrencyTitleButton(_ currencyDelegateManager: CurrencyDelegateManager?) {
        currencyTitleButton.addTarget(target, action: action, for: .touchUpInside)
        self.currencyDelegateManager = currencyDelegateManager
        currencyDelegateManager?.currencyDelegate = self
        navigationItem.titleView = currencyTitleButton
    }
    
    // MARK: - Private Methods
    @objc private func currencyButtonAction() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300.0
        
        bottomSheetController.addNavigationBar("Preferred Currency")
        
        bottomSheetController.addTableView { [weak self] tableView in
            tableView.separatorStyle = .none
            
            guard let currencyDelegateManager = self?.currencyDelegateManager else { return }
            tableView.registerNibs(for: currencyDelegateManager.currencyCellModelsForRegistration)
            tableView.delegate = currencyDelegateManager
            tableView.dataSource = currencyDelegateManager
        }
        
        bottomSheetController.present()
    }
    
    
    func hideAll() {
        hideHUD()
        refreshControl?.endRefreshing()
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
        self.lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset.y < scrollView.contentOffset.y) {
            UIView.animate(withDuration: 0.3) {
                self.filterStackView.alpha = 0.0
            }
        } else if (self.lastContentOffset.y > scrollView.contentOffset.y) {
            UIView.animate(withDuration: 0.3) {
                self.filterStackView.alpha = 1.0
            }
        }
    }
}

extension BaseViewController: CurrencyDelegateManagerProtocol {
    func didSelectCurrency(at indexPath: IndexPath) {
        if let selectedCurrency = currencyDelegateManager?.selectedCurrency {
            currencyTitleButton.setTitle(selectedCurrency, for: .normal)
            currencyTitleButton.sizeToFit()
        }
        
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
    
    @objc func dateRangeButtonAction() {
        
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
        
        mailComposerVC.setToRecipients([Constants.Urls.feedbackEmailAddress])
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
    
class BaseViewControllerWithTableView: BaseViewController, UIViewControllerWithTableView, UIViewControllerWithFetching {
    // MARK: - Veriables
    var tableView: UITableView!
    var fetchMoreActivityIndicator: UIActivityIndicatorView!
    var previousViewController: UIViewController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addTableViewIfNeeded()
        setupViews()
        setupAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.delegate = self
    }
    
    // MARK: - Private methods
    private func addTableViewIfNeeded() {
        if tableView == nil {
            tableView = UITableView(frame: .zero, style: .plain)
            self.view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            if #available(iOS 11, *) {
                let guide = self.view.safeAreaLayoutGuide
                tableView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1.0).isActive = true
                
            } else {
                let standardSpacing: CGFloat = 0.0
                tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing).isActive = true
            }
        }
    }
    
    private func setupViews() {
        tableView.separatorStyle = .none
        
        fetchMoreActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        fetchMoreActivityIndicator.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        fetchMoreActivityIndicator.color = UIColor.primary
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.separatorInset.left = 16.0
        tableView.separatorInset.right = 16.0
        
        tableView.backgroundColor = .clear

        filterStackView.addArrangedSubview(sortButton)
        filterStackView.addArrangedSubview(filterButton)
        bottomStackView.addArrangedSubview(signInButton)
        bottomStackView.addArrangedSubview(filterStackView)
        
        view.addSubview(bottomStackView)
        
        bottomViewType = .none
    }
    
    private func setupAutoLayout() {
        sortButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        dateRangeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dateRangeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        filterButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        signInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 198).isActive = true
        
        filterStackView.leftAnchor.constraint(equalTo: bottomStackView.leftAnchor, constant: 0).isActive = true
        filterStackView.rightAnchor.constraint(equalTo: bottomStackView.rightAnchor, constant: 0).isActive = true
        filterStackView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 0).isActive = true
        filterStackView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        bottomStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        bottomStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        if #available(iOS 11, *) {
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        } else {
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        }
        
    }
    
    
    // MARK: - Fetching
    func updateData() {
        showProgressHUD()
        fetch()
    }
    
    func fetch() {
        //Fetch first page
    }
    
    func fetchMore() {
        //Fetch next page
    }
    
    func showInfiniteIndicator(value: Bool) {
        guard value, fetchMoreActivityIndicator != nil else {
            tableView.tableFooterView = UIView()
            return
        }
        
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
    }
}

extension BaseViewControllerWithTableView: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        guard previousViewController == viewController,
            let navController = viewController as? BaseNavigationController,
            let tabsType = TabsType(rawValue: tabBarIndex) else { return }
    
        switch tabsType {
        case .dashboard:
            if let vc = navController.viewControllers.first as? UIViewControllerWithScrollView, let scrollView = vc.scrollView {
                scrollTop(scrollView)
            }
        case .programList:
            if let vc = navController.viewControllers.first as? ProgramListViewController, let tableView = vc.tableView {
                scrollTop(tableView)
            }
        case .wallet:
            if let vc = navController.viewControllers.first as? WalletViewController, let tableView = vc.tableView {
                scrollTop(tableView)
            }
        case .profile:
            if let vc = navController.viewControllers.first as? ProfileViewController, let tableView = vc.tableView {
                scrollTop(tableView)
            }
        }
    }
    
    func scrollTop(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        previousViewController = tabBarController.selectedViewController
        return true
    }
}

// MARK: - EmptyData
extension BaseViewControllerWithTableView: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.getFont(.bold, size: 25)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        fetchMoreActivityIndicator.stopAnimating()
        return 40
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.noDataPlaceholder
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.BaseView.bg
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        updateData()
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        let capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)
        let rectInsets = UIEdgeInsetsMake(0, -20, 0.0, -20)
        var image: UIImage = #imageLiteral(resourceName: "img_button")
        
        if state == .highlighted {
            image = #imageLiteral(resourceName: "img_button_highlighted")
        }
        
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withAlignmentRectInsets(rectInsets)
    }
}

extension BaseTableViewController: UIViewControllerWithPullToRefresh {
    
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

class BaseTableViewController: UITableViewController, UIViewControllerWithFetching, Hidable {
    // MARK: - Variables
    var fetchMoreActivityIndicator: UIActivityIndicatorView!
    
    var prefersLargeTitles: Bool = true {
        didSet {
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonSetup()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTheme()
    }
    
    // MARK: - Fetching
    func updateData() {
        showProgressHUD()
        fetch()
    }
    
    func fetch() {
        //Fetch first page
    }
    
    func fetchMore() {
        //Fetch next page
    }
    
    func showInfiniteIndicator(value: Bool) {
        guard value, fetchMoreActivityIndicator != nil else {
            tableView.tableFooterView = UIView()
            return
        }
        
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
    }
    
    func hideAll() {
        hideHUD()
        refreshControl?.endRefreshing()
    }
    
    func setupViews() {
        tableView.separatorStyle = .none
        
        fetchMoreActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        fetchMoreActivityIndicator.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        fetchMoreActivityIndicator.color = UIColor.primary
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
        
        tableView.backgroundColor = .clear
        
        tableView.separatorInset.left = 16.0
        tableView.separatorInset.right = 16.0
        
        refreshControl?.endRefreshing()
    }
}
