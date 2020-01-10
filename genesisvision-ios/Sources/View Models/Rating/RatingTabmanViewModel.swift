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
    var tabTypes = [Int]()
    
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
        
        BaseDataProvider.getProgramsLevels(getPlatformCurrencyType(), completion: { [weak self] (viewModel) in
            self?.updateItems(viewModel)
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
    
    func updateItems(_ levelsInfo: ProgramsLevelsInfo?) {
        guard let levelsInfo = levelsInfo, let levels = levelsInfo.levels else { return }
        
        self.filterModel.levelsInfo = levelsInfo
        self.dataSource = PageboyDataSource(self)
        
        tabTypes = levels.map({ $0.level ?? 0 })
        
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

extension RatingTabmanViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        let type = tabTypes[index]
        
        switch type {
        case .info:
            if let router = router as? ProgramTabmanRouter, let assetId = assetId, let vc = router.getInfo(with: assetId) {
                return vc
            }
        default:
            break
        }
        
        return nil
    }
}
