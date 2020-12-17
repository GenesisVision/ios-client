//
//  AssetsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class AssetsViewController: BaseTabmanViewController<AssetsTabmanViewModel> {
    // MARK: - Variables
    private var searchViewController: SearchViewController = SearchViewController()
    var searchNavController: BaseNavigationController?
    
    private var searchBarButtonItem: UIBarButtonItem!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        if viewModel.searchBarEnable {
            searchBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_search_icon"), style: .done, target: self, action: #selector(openSearchMethod))
            
            navigationItem.rightBarButtonItems = [searchBarButtonItem]
        }
        
        guard viewModel.router is DashboardRouter else {
            NotificationCenter.default.addObserver(self, selector: #selector(chooseFundListDidTapped(_:)), name: .chooseFundList, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(chooseProgramListDidTapped(_:)), name: .chooseProgramList, object: nil)
            return
        }
    }
    
    // MARK: - Private methods
    @objc private func chooseProgramListDidTapped(_ notification: Notification) {
        scrollToPage(.first, animated: true)
    }
    
    @objc private func chooseFundListDidTapped(_ notification: Notification) {
        scrollToPage(.last, animated: true)
    }
    
    @objc func openSearchMethod() {
        searchViewController.searchProtocol = self
        let router = Router(parentRouter: viewModel.router, navigationController: navigationController)
        let searchViewModel = SearchTabmanViewModel(withRouter: router)
        searchViewModel.filterModel.mask = ""
        searchViewController.viewModel = searchViewModel
        searchNavController = BaseNavigationController(rootViewController: searchViewController)
        searchNavController?.modalPresentationStyle = .overCurrentContext
        present(searchNavController!, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .chooseFundList, object: nil)
        NotificationCenter.default.removeObserver(self, name: .chooseProgramList, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func scrollToTop() {
        
    }
}

extension AssetsViewController: SearchViewControllerProtocol {
    func didClose() {
        searchNavController?.dismiss(animated: true, completion: nil)
    }
    
    func didSelect(_ assetId: String, assetType: AssetType) {
        searchNavController?.dismiss(animated: true, completion: nil)
    }
}
