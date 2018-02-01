//
//  FilterViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class FilterViewController: BaseViewController {

    // MARK: - View Model
    var viewModel: FilterViewModel!
    
    // MARK: - Variables
    private var resetBarButtonItem: UIBarButtonItem?
    
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
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        title = viewModel.title
        view.backgroundColor = UIColor(.lightGray)
        
        resetBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonAction(_:)))
        navigationItem.rightBarButtonItem = resetBarButtonItem
    }
    
    private func setupTableConfiguration() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.registerNibs(for: viewModel.registerNibs())
    }
    
    // MARK: - IBAction
    @IBAction func applyButtonAction(_ sender: UIButton) {
        viewModel.apply()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        viewModel.reset()
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.model(for: indexPath)
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsIn(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}

extension FilterViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
