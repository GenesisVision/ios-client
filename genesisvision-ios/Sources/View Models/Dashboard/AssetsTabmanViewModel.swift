//
//  AssetsTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

class AssetsTabmanViewModel: TabmanViewModel {
    enum TabType: String {
        case follows = "Follows", funds = "Funds", programs = "Programs", assets = "Assets"
    }
    var tabTypes: [TabType] = [.follows, .funds, .programs, .assets]
    var controllers = [TabType : UIViewController]()
    
    var filterModel: FilterModel = FilterModel()
    var searchBarEnable = false
    var showFacets = false
    
    // MARK: - Init
    init(withRouter router: Router, searchBarEnable: Bool = false, showFacets: Bool = false) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
    
        title = "Invest"
        font = UIFont.getFont(.semibold, size: 16)
        
        self.searchBarEnable = searchBarEnable
        self.showFacets = showFacets
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        switch type {
        case .programs:
            return controllers[type] ?? router.getPrograms(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        case .funds:
            return controllers[type] ?? router.getFunds(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        case .follows:
            return controllers[type] ?? router.getFollows(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        case .assets:
            return controllers[type] ?? router.getCoinAssets(with: FilterModel(), showFacets: showFacets, parentRouter: router)
        }
    }
}

extension AssetsTabmanViewModel: TabmanDataSourceProtocol {
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
