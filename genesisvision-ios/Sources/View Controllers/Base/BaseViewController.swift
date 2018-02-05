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

        view.backgroundColor = UIColor.background
    }
}

class BaseViewControllerWithTableView: BaseViewController, UIViewControllerWithTableView {
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.configure(with: .defaultConfiguration)
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = UIColor.background
    }
}

extension BaseViewControllerWithTableView: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No data"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Update"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.primary]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.background
    }
}
