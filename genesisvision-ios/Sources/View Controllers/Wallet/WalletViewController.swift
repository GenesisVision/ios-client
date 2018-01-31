//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class WalletViewController: BaseViewController {

    // MARK: - View Model
    var viewModel: WalletViewModel!
    
    // MARK: - Variables
    @IBOutlet var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let balance = viewModel.getBalance()
        navigationItem.title = String(describing: balance) + " GVT"
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        fetch()
    }
    
    private func setupUI() {
        title = "Wallet"
    }
    
    private func setupTableConfiguration() {
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    
    private func fetch() {
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                let balance = self?.viewModel.getBalance()
                self?.navigationItem.title = String(describing: balance) + " GVT"
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
}

extension WalletViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    //DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No data"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor(.darkGray)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Update"
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor(.blue)]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(.lightGray)
    }
    
    //DZNEmptyDataSetDelegate
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        //TODO: showProgressHUD()
        //TODO: pullToRefresh()
    }
}
