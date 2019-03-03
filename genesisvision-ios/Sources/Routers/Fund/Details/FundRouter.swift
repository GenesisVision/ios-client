//
//  FundRouter.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum FundRouteType {
    case notificationSettings(assetId: String, title: String)
}

class FundRouter: Router {
    var fundViewController: FundViewController!
    
    var fundHeaderViewController: FundHeaderViewController?
    var fundDetailsTabmanViewController: FundTabmanViewController?
    
    var fundBalanceViewController: FundBalanceViewController?
    var fundProfitViewController: FundProfitViewController?
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, fundViewController: FundViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.fundViewController = fundViewController
        self.currentController = fundViewController
    }
    
    // MARK: - Public methods
    func show(routeType: FundRouteType) {
        switch routeType {
        case .notificationSettings(let assetId, let title):
            showAssetNotificationsSettings(assetId, title: title, type: .fund)
        }
    }
}
