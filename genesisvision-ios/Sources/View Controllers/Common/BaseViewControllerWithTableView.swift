//
//  BaseViewControllerWithTableView.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BaseViewControllerWithTableView: BaseViewController, UIViewControllerWithTableView, UIViewControllerWithFetching {
    // MARK: - Veriables
    var tableView: UITableView!
    var fetchMoreActivityIndicator: UIActivityIndicatorView!
    var previousViewController: UIViewController?
    var tableViewStyle: UITableView.Style = .plain
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableViewIfNeeded()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.delegate = self
    }
    
    // MARK: - Private methods
    private func addTableViewIfNeeded() {
        if tableView == nil {
            tableView = UITableView(frame: .zero, style: tableViewStyle)
            self.view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        }
    }
    
    private func setupViews() {
        tableView.separatorStyle = .none
        
        fetchMoreActivityIndicator = UIActivityIndicatorView(style: .gray)
        fetchMoreActivityIndicator.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        fetchMoreActivityIndicator.color = UIColor.primary
        fetchMoreActivityIndicator.startAnimating()
        tableView.tableFooterView = fetchMoreActivityIndicator
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.separatorInset.left = 16.0
        tableView.separatorInset.right = 16.0
        
        tableView.backgroundColor = UIColor.BaseView.bg
        tableView.tableHeaderView?.backgroundColor = UIColor.Cell.headerBg
        
        addBottomView()
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
    
    func register3dTouch() {
        
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
        case .assetList:
            if let vc = navController.viewControllers.first as? ProgramListViewController, let tableView = vc.tableView {
                scrollTop(tableView)
            }
        case .wallet:
            break
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
        let text = noDataTitle ?? ""
        
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.Font.nodata,
                          NSAttributedString.Key.font : UIFont.getFont(.regular, size: 14)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        fetchMoreActivityIndicator.stopAnimating()
        return 40
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return noDataImage ?? UIImage.noDataPlaceholder
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
    
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        let capInsets = UIEdgeInsets.init(top: 22.0, left: 22.0, bottom: 22.0, right: 22.0)
        let rectInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0.0, right: -20)
        var image: UIImage = #imageLiteral(resourceName: "img_button")
        
        if state == .highlighted {
            image = #imageLiteral(resourceName: "img_button_highlighted")
        }
        
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withAlignmentRectInsets(rectInsets)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = noDataButtonTitle ?? ""
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.Cell.title,
                          NSAttributedString.Key.font : UIFont.getFont(.regular, size: 14)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
