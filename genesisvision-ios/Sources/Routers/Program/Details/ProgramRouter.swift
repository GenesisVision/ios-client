//
//  ProgramRouter.swift
//  genesisvision-ios
//
//  Created by George on 28/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINavigationController

enum ProgramRouteType {
    case notificationSettings(assetId: String, title: String)
    case aboutLevels(currency: PlatformAPI.Currency_v10PlatformLevelsGet)
}

class ProgramRouter: Router {
    var programViewController: ProgramViewController!
    
    var programHeaderViewController: ProgramHeaderViewController?
    var programDetailsTabmanViewController: ProgramTabmanViewController?
    
    var programBalanceViewController: ProgramBalanceViewController?
    var programProfitViewController: ProgramProfitViewController?
    
    // MARK: - Lifecycle
    init(parentRouter: Router?, navigationController: UINavigationController?, programViewController: ProgramViewController) {
        super.init(parentRouter: parentRouter, navigationController: navigationController)
        
        self.programViewController = programViewController
        self.currentController = programViewController
    }
    
    // MARK: - Public methods
    func show(routeType: ProgramRouteType) {
        switch routeType {
        case .notificationSettings(let assetId, let title):
            showAssetNotificationsSettings(assetId, title: title, type: .program)
        case .aboutLevels(let currency):
            showAboutLevels(currency)
        }
    }
}
