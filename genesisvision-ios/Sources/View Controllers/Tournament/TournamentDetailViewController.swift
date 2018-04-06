//
//  TournamentDetailViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TournamentDetailViewController: BaseViewControllerWithTableView {
    
    // MARK: - View Model
    var viewModel: TournamentDetailViewModel! {
        didSet {
            title = viewModel.getNickname()
            
            updateData()
        }
    }
    
    // MARK: - Variables
    private var ipfsHashBarButtonItem: UIBarButtonItem! {
        return UIBarButtonItem(image: UIImage.NavBar.ipfsList, style: .done, target: self, action: #selector(ipfsHashButtonAction(_:)))
    }
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showInfiniteIndicator(value: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideAll()
    }
    
    // MARK: - Private methods
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNibs(for: TournamentDetailViewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: TournamentDetailViewModel.viewModelsForRegistration)
        showInfiniteIndicator(value: false)
        
        setupPullToRefresh()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.setupNavigationBar()
                self?.tableView.reloadData()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.setTitle(title: viewModel.title, subtitle: getVersion())
        
        guard viewModel.ipfsHash() != nil else {
            print("Incorrect ipfsHashURL")
            navigationItem.rightBarButtonItem = nil
            return
        }
  
        navigationItem.rightBarButtonItem = ipfsHashBarButtonItem
    }
    
    // MARK: - IBActions
    @IBAction func ipfsHashButtonAction(_ sender: UIButton) {
        guard let ipfsHashURL = viewModel.ipfsHash() else {
            print("Incorrect ipfsHashURL")
            return
        }
        
        openSafariVC(with: ipfsHashURL)
    }
}

extension TournamentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView() as DefaultTableHeaderView
        header.headerLabel.text = title
        return header
    }
}
