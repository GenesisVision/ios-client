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
    var resultsViewController: SearchViewController?
    
    var timer: Timer?
    
    // MARK: - Outlets
    var searchController = UISearchController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title
        
        self.dataSource = viewModel.dataSource
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
        resultsViewController = SearchViewController()
        let router = Router(parentRouter: viewModel.router, navigationController: navigationController)
        let searchViewModel = SearchTabmanViewModel(withRouter: router)
        searchViewModel.filterModel.mask = ""
        resultsViewController?.viewModel = searchViewModel
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        //UI
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.setImage(#imageLiteral(resourceName: "img_search_icon"), for: UISearchBarIcon.search, state: .normal)
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.searchBarStyle = .minimal
        
        searchController.searchBar.tintColor = UIColor.primary
        searchController.searchBar.barTintColor = UIColor.primary
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.inputView?.tintColor = UIColor.primary
        
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }

        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.primary
        }
        
        definesPresentationContext = true
    }
    
    @objc private func performSearch() {
        resultsViewController?.performSearch()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        resultsViewController?.viewModel.filterModel.mask = text
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
    }
}
