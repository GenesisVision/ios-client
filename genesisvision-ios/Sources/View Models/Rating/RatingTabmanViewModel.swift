//
//  RatingTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 03/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

final class RatingTabmanViewModel: TabmanViewModel {
    var dataSource: RatingPageboyViewControllerDataSource!
    
    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    
    // MARK: - Init
    init(withRouter router: Router, searchBarEnable: Bool = false, showFacets: Bool = false) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Rating"
        font = UIFont.getFont(.semibold, size: 16)
        
        self.searchBarEnable = searchBarEnable
        self.showFacets = showFacets
        self.dataSource = RatingPageboyViewControllerDataSource(router: router, showFacets: showFacets)
        
//        BaseDataProvider.getProgramsLevels(<#T##currency: PlatformAPI.Currency_getProgramLevels##PlatformAPI.Currency_getProgramLevels#>, completion: <#T##(ProgramsLevelsInfo?) -> Void#>, errorCompletion: <#T##CompletionBlock##CompletionBlock##(CompletionResult) -> Void#>)
//        ProgramsDataProvider.getLevelUpSummary(completion: { [weak self] (levelUpSummary) in
//            self?.updateItems(levelUpSummary)
//        }) { (result) in
//            switch result {
//            case .success:
//                break
//            case .failure(let errorType):
//                print(errorType)
//                ErrorHandler.handleError(with: errorType)
//            }
//        }
    }
    
    func updateItems(_ levelsInfo: ProgramsLevelsInfo?) {
        guard let levelsInfo = levelsInfo, let levels = levelsInfo.levels else { return }
        
        self.filterModel.levelsInfo = levelsInfo
        self.dataSource = RatingPageboyViewControllerDataSource(router: router, showFacets: showFacets)
        
        var items: [TMBarItem] = []
        for level in levels {
            if let levelValue = level.level {
                items.append(TMBarItem(title: "\(levelValue) ⤍ \(levelValue + 1)"))
            }
        }
        
        self.items = items
    }
    
    func showAboutLevels() {
        router.showAboutLevels(.gvt)
    }
}
