//
//  CoinAssetInvestRouter.swift
//  genesisvision-ios
//
//  Created by Gregory on 26.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetInvestRouter : Router {
    func getInvestingPortfolioListViewController(type: InvestingPortfolioSectionType) -> AssetInvestingPortfolioListViewController {
        let assetInvestingPortfolioListViewController = AssetInvestingPortfolioListViewController()
        let viewModel = InvestingAssetPortfolioViewModel(withRouter: parentRouter ?? Router(parentRouter: nil), reloadDataProtocol: assetInvestingPortfolioListViewController, type: type)
        assetInvestingPortfolioListViewController.viewModel = viewModel
        
        return assetInvestingPortfolioListViewController
    }
}
