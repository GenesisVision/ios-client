//
//  RatingsTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 03/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

final class RatingsTabmanViewModel: TabmanViewModel {
    var dataSource: RatingsPageboyViewControllerDataSource!
    
    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate? = nil, searchBarEnable: Bool = false, showFacets: Bool = false) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Ratings"
        font = UIFont.getFont(.semibold, size: 16)
        
        self.searchBarEnable = searchBarEnable
        self.showFacets = showFacets
        self.tabmanViewModelDelegate = tabmanViewModelDelegate
        self.dataSource = RatingsPageboyViewControllerDataSource(router: router, filterModel: filterModel, showFacets: showFacets)
        
        ProgramsDataProvider.getLevelUpSummary(completion: { [weak self] (levelUpSummary) in
            self?.updateItems(levelUpSummary)
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    func updateItems(_ levelUpSummary: LevelUpSummary?) {
        guard let levelUpSummary = levelUpSummary, let levelData = levelUpSummary.levelData else { return }
        
        self.filterModel.levelUpSummary = levelUpSummary
        self.dataSource = RatingsPageboyViewControllerDataSource(router: router, filterModel: filterModel, showFacets: showFacets)
        
        var items: [TabmanBar.Item] = []
        for data in levelData {
            if let level = data.level {
                items.append(TabmanBar.Item(title: "\(level) -> \(level + 1)"))
            }
        }
        
        self.items = items
        tabmanViewModelDelegate?.updatedItems()
    }
}
