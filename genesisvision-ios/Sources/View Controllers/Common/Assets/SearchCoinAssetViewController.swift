//
//  SearchCoinAssetViewController.swift
//  genesisvision-ios
//
//  Created by Gregory on 23.05.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

protocol SearchAssetsFilterViewModelProtocol {
    func updateSelectedAsset(asset: String)
}
protocol SearchAssetsManagerProtocol {
    var allConstant: String { get }
}

class SearchCoinAssetViewController: BaseTabmanViewController<SearchCoinAssetTabmanViewModel> {
    // MARK: - Variables
    
    var searchController = UISearchController()
    var timer: Timer?
    weak var searchProtocol: SearchViewControllerProtocol?
    var isFiltering : Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var searchBarIsEmpty : Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    var filterManagerDelegate: SearchAssetsFilterViewModelProtocol?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        dataSource = viewModel.dataSource
        setupSearchBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        //UI
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.setImage(#imageLiteral(resourceName: "img_search_icon"), for: UISearchBar.Icon.search, state: .normal)
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.searchBarStyle = .minimal
        
        searchController.searchBar.tintColor = UIColor.primary
        searchController.searchBar.barTintColor = UIColor.primary
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.inputView?.tintColor = UIColor.primary
        
        navigationItem.titleView = searchController.searchBar
        extendedLayoutIncludesOpaqueBars = false
        navigationItem.hidesSearchBarWhenScrolling = true

        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.primary
        }
        
        definesPresentationContext = true
    }
    // MARK: - Public methods
    @objc func performSearch() {
        viewModel.search()
        viewModel.updateControllers(isFiltering: isFiltering)
    }
    
    func clearResults() {
        viewModel.updateControllers(isFiltering: isFiltering)
    }
    
    func pushSelectedCoin(asset: String) {
        filterManagerDelegate?.updateSelectedAsset(asset: asset)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchCoinAssetViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            viewModel.filterModel.mask = ""
            clearResults()
            timer?.invalidate()
            return
        }
        viewModel.filterModel.mask = text
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
    }
}

extension SearchCoinAssetViewController: SearchAssetsManagerProtocol {
    var allConstant: String {
        "All"
    }
}
