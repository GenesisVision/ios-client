//
//  InvestingAssetTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 26.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

final class InvestingAssetTabmanViewModel: TabmanViewModel {
    enum TabType: String {
        case portfolio = "Portfolio", history = "History"
    }
    var tabTypes: [TabType] = [.portfolio, .history]
    var controllers = [TabType : UIViewController]()
    
    
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        font = UIFont.getFont(.semibold, size: 16)
        tabTypes = [.portfolio, .history]
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        guard let router = router as? CoinAssetInvestRouter else { return nil }
        
        switch type {
        case .portfolio:
            return controllers[type] ?? router.getInvestingPortfolioListViewController(type: .portfolio)
        case .history:
            return controllers[type] ?? router.getInvestingPortfolioListViewController(type: .history)
        }
    }
}

extension InvestingAssetTabmanViewModel: TabmanDataSourceProtocol {
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
