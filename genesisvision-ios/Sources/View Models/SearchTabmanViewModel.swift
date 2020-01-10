//
//  SearchTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

final class SearchTabmanViewModel: TabmanViewModel {
    enum TabType: String {
        case follows = "Follows", funds = "Funds", programs = "Programs", managers = "Managers"
    }
    var tabTypes: [TabType] = [.follows, .funds, .programs, .managers]
    var controllers = [TabType : UIViewController]()
    
    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    var take = ApiKeys.take
    
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Search"
        
        font = UIFont.getFont(.semibold, size: 16)
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    // MARK: - Public methods
    func fetch(_ completionSuccess: @escaping (_ viewModel: CommonPublicAssetsViewModel?) -> Void, completionError: @escaping CompletionBlock) {
        SearchDataProvider.get(filterModel.mask, take: take, completion: { (viewModel) in
            completionSuccess(viewModel)
        }, errorCompletion: completionError)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        switch type {
        case .follows:
            return router.getFollows(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        case .funds:
            return router.getFunds(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        case .programs:
            return router.getPrograms(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        case .managers:
            return router.getManagers(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        }
    }
}

extension SearchTabmanViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        return getViewController(tabTypes[index])
    }
}
