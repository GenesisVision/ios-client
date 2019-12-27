//
//  SearchViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

class SearchViewController: BaseTabmanViewController<SearchTabmanViewModel> {
    // MARK: - Variables
    var pageboyDataSource: SearchPageboyViewControllerDataSource!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        
        pageboyDataSource = SearchPageboyViewControllerDataSource(router: viewModel.router, showFacets: viewModel.showFacets)
        self.dataSource = pageboyDataSource
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Public methods
    func performSearch() {
        viewModel.fetch({ [weak self] (viewModel) in
            if let viewModel = viewModel {
                self?.updateControllers(viewModel)
            }
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
        let searchViewModel = CommonPublicAssetsViewModel(programs: ItemsViewModelProgramDetailsListItem(items: [], total: 0),
                                              funds: ItemsViewModelFundDetailsListItem(items: [], total: 0),
                                              follows: ItemsViewModelFollowDetailsListItem(items: [], total: 0),
                                              managers: ItemsViewModelPublicProfile(items: [], total: 0))
        self.updateControllers(searchViewModel)
    }
    
    private func updateControllers(_ searchViewModel: CommonPublicAssetsViewModel?) {
        for vc in pageboyDataSource.controllers {
            if let vc = vc as? ProgramListViewController, let viewModel = vc.viewModel {
                viewModel.updateViewModels(searchViewModel?.programs)
            } else if let vc = vc as? FundListViewController, let viewModel = vc.viewModel {
                viewModel.updateViewModels(searchViewModel?.funds)
            } else if let vc = vc as? ManagerListViewController, let viewModel = vc.viewModel as? ManagerListViewModel {
                viewModel.updateViewModels(searchViewModel?.managers)
            }
        }
    }
}

