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

    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    var take = ApiKeys.take
    
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Search"
        
        items = [TMBarItem(title: "Programs"),
                 TMBarItem(title: "Funds"),
                 TMBarItem(title: "Managers")]
        
        font = UIFont.getFont(.semibold, size: 16)
    }
    
    // MARK: - Public methods
    func fetch(_ completionSuccess: @escaping (_ viewModel: SearchViewModel?) -> Void, completionError: @escaping CompletionBlock) {
        SearchDataProvider.get(filterModel.mask, take: take, completion: { (viewModel) in
            completionSuccess(viewModel)
        }, errorCompletion: completionError)
    }
}
