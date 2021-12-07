//
//  SearchViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

protocol SearchViewControllerProtocol: AnyObject {
    func didClose()
    func didSelect(_ assetId: String, assetType: AssetType)
}

class SearchViewController: BaseTabmanViewController<SearchTabmanViewModel> {
    // MARK: - Variables
    var pageboyDataSource: SearchPageboyViewControllerDataSource!
    private var closeBarButtonItem: UIBarButtonItem?
    
    var searchController = UISearchController()
    var timer: Timer?
    weak var searchProtocol: SearchViewControllerProtocol?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        pageboyDataSource = SearchPageboyViewControllerDataSource(router: viewModel.router, showFacets: viewModel.showFacets, searchProtocol: searchProtocol)
        self.dataSource = pageboyDataSource
        
        closeBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_close_icon"), style: .done, target: self, action: #selector(closeButtonAction(_:)))
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
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
        viewModel.fetch({ [weak self] (viewModel) in
            self?.updateControllers(viewModel)
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    func clearResults() {
        
        let searchViewModel = CommonPublicAssetsViewModel(programs: ProgramDetailsListItemItemsViewModel(items: [], total: 0),
                                                          funds: FundDetailsListItemItemsViewModel(items: [], total: 0),
                                                          follows: FollowDetailsListItemItemsViewModel(items: [], total: 0),
                                                          managers: PublicProfileItemsViewModel(items: [], total: 0))
        self.updateControllers(searchViewModel)
    }
    
    private func updateControllers(_ searchViewModel: CommonPublicAssetsViewModel?) {
        for vc in pageboyDataSource.controllers {
            if let vc = vc as? ProgramListViewController, let viewModel = vc.viewModel, viewModel.assetType == .follow {
                viewModel.updateViewModels(searchViewModel?.follows)
                bar.items?[0].badgeValue = String(searchViewModel?.follows?.items?.count ?? 0)
            } else if let vc = vc as? FundListViewController, let viewModel = vc.viewModel {
                viewModel.updateViewModels(searchViewModel?.funds)
                bar.items?[1].badgeValue = String(searchViewModel?.funds?.items?.count ?? 0)
            } else if let vc = vc as? ProgramListViewController, let viewModel = vc.viewModel, viewModel.assetType == .program {
                viewModel.updateViewModels(searchViewModel?.programs)
                bar.items?[2].badgeValue = String(searchViewModel?.programs?.items?.count ?? 0)
            } else if let vc = vc as? ManagerListViewController, let viewModel = vc.viewModel {
                viewModel.updateViewModels(searchViewModel?.managers)
                bar.items?[3].badgeValue = String(searchViewModel?.managers?.items?.count ?? 0)
            }
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        searchProtocol?.didClose()
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            viewModel.filterModel.mask = ""
            clearResults()
            timer?.invalidate()
            return
        }
        viewModel.filterModel.mask = text

        timer?.invalidate()

        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
    }
}
