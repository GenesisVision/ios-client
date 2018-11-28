//
//  AssetsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class AssetsViewController: BaseTabmanViewController<AssetsTabmanViewModel>, UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - Variables
    var pageboyDataSource: AssetsPageboyViewControllerDataSource!

    var resultsViewController: AssetsViewController?
    
    var timer: Timer?
    
    // MARK: - Outlets
    var searchController = UISearchController()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title
        
        pageboyDataSource = AssetsPageboyViewControllerDataSource(router: viewModel.router, filterModel: viewModel.filterModel, showFacets: viewModel.showFacets)
        self.dataSource = pageboyDataSource
        
        self.bar.items = viewModel.items
        
        if viewModel.searchBarEnable {
            setupSearchBar()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func setupSearchBar() {
        resultsViewController = AssetsViewController()
        let router = Router(parentRouter: viewModel.router, navigationController: navigationController)
        let searchViewModel = AssetsTabmanViewModel(withRouter: router)
        searchViewModel.filterModel.mask = ""
        resultsViewController?.viewModel = searchViewModel
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        //UI
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.backgroundColor = UIColor.BaseView.bg
        searchController.searchBar.barTintColor = UIColor.primary
        searchController.searchBar.tintColor = UIColor.primary
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.inputView?.tintColor = UIColor.primary
        
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        resultsViewController?.viewModel.filterModel.mask = text
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
    }
    
    @objc func performSearch() {
        guard let controllers = resultsViewController?.pageboyDataSource.controllers else { return }
        
        for vc in controllers {
            if let vc = vc as? ProgramListViewController {
                vc.fetch()
            } else if let vc = vc as? FundListViewController {
                vc.fetch()
            }
        }
    }
}
