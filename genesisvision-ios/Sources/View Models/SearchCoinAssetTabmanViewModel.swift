//
//  SearchCoinAssetTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 23.05.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation
import Tabman

final class SearchCoinAssetTabmanViewModel: TabmanViewModel {
    var tabTypes: [SearchCoinTabType] = [.binance, .huobi]
    var controllers = [SearchCoinTabType : UIViewController]()
    var filterModel: FilterModel = FilterModel()

    // MARK: - Init
    init(withRouter router: Router, delegate: SearchCoinAssetViewController) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Search"
        
        font = UIFont.getFont(.semibold, size: 16)
        self.tabTypes.forEach({ self.controllers[$0] = self.getViewController($0, delegate: delegate) })
        self.dataSource = PageboyDataSource(self)
    }
    
    // MARK: - Public methods
    func search() {
        for controller in controllers.values {
            if let vc = controller as? SearchCoinAssetsListViewController {
                guard let text = filterModel.mask else { return }
                vc.filter(text: text)
            }
        }
    }
    
    func updateControllers(isFiltering: Bool) {
        for controller in controllers.values {
            if let vc = controller as? SearchCoinAssetsListViewController {
                vc.isFiltering = isFiltering
            }
        }
    }
    
    func getViewController(_ type: SearchCoinTabType, delegate: SearchCoinAssetViewController?) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        switch type {
        case .binance:
            let vc = SearchCoinAssetsListViewController()
            vc.type = .binance
            vc.delegate = delegate
            return vc
        case .huobi:
            let vc = SearchCoinAssetsListViewController()
            vc.type = .huobi
            vc.delegate = delegate
            return vc
        }
    }
}

extension SearchCoinAssetTabmanViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        return getViewController(tabTypes[index], delegate: nil)
    }
}
