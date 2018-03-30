//
//  BaseViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Background.main
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    }
    
    // MARK: - Public methods
    func setupNavigationBar(with style: ColorStyle = .white) {
        let colors = StyleColors(with: style)
        
        AppearanceController.setupNavigationBar(with: style)
        
        navigationController?.navigationBar.tintColor = colors.tintColor
        navigationController?.navigationBar.backgroundColor = colors.tintColor
        navigationController?.navigationBar.barTintColor = colors.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.textColor,
                                                                   NSAttributedStringKey.font: UIFont.getFont(.bold, size: 18)]
    }
    
    func hideAll() {
        hideHUD()
    }
}

class BaseViewControllerWithTableView: BaseViewController, UIViewControllerWithTableView, UIViewControllerWithFetching {
    
    // MARK: - Veriables
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var canFetchMoreResults = true
    var previousViewController: UIViewController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.separatorInset.left = 16.0
        tableView.separatorInset.right = 16.0
        
        tabBarController?.delegate = self
        
        view.backgroundColor = UIColor.Background.main
        tableView.backgroundColor = UIColor.Background.main
        
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Fetching
    func updateData() {
        showProgressHUD()
        fetch()
    }
    
    @objc func pullToRefresh() {
        feedback()
    }
    
    func fetch() {
        //Fetch first page
    }
    
    func fetchMore() {
        //Fetch next page
    }
    
    override func hideAll() {
        DispatchQueue.main.async {
            self.hideHUD()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func setupPullToRefresh(title: String? = nil) {
        let tintColor = UIColor.primary
        let attributes = [NSAttributedStringKey.foregroundColor : tintColor]
        
        refreshControl = UIRefreshControl()
        if let title = title {
            refreshControl.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        }
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
            if let vc = navController.viewControllers.first as? DashboardViewController, let tableView = vc.tableView {
                tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        case .programList:
            if let vc = navController.viewControllers.first as? ProgramListViewController, let tableView = vc.tableView {
                tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        case .wallet:
            if let vc = navController.viewControllers.first as? WalletViewController, let tableView = vc.tableView {
                tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        case .profile:
            if let vc = navController.viewControllers.first as? ProfileViewController, let tableView = vc.tableView {
                tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
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
        return 40
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.noDataPlaceholder
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.Background.main
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
