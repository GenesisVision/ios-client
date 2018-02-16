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
    }
}

class BaseViewControllerWithTableView: BaseViewController, UIViewControllerWithTableView {
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.configure(with: .defaultConfiguration)
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = UIColor.Background.main
    }
}

extension BaseViewControllerWithTableView: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No data"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.Font.dark,
                          NSAttributedStringKey.font : UIFont.systemFont(ofSize: 25, weight: .bold)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 40
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Update"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.primary]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.placeholder
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.Background.main
    }
}
