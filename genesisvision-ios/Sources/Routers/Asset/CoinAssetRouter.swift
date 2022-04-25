//
//  CoinAssetRouter.swift
//  genesisvision-ios
//
//  Created by Gregory on 05.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetRouter {
    static func showBuyViewController(portfolioAsset: CoinsAsset?, navigationController: UINavigationController?) {
        guard let viewController = CoinAssetBuyOrSellViewController.storyboardInstance(.assets),
              let portfolioAsset = portfolioAsset else { return }

        viewController.viewModel = CoinAssetBuyAndSellViewModel(asset: portfolioAsset)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    static func showSellViewController(portfolioAsset: CoinsAsset?, navigationController: UINavigationController?) {
        guard let viewController = CoinAssetBuyOrSellViewController.storyboardInstance(.assets),
              let portfolioAsset = portfolioAsset else { return }

        viewController.viewModel = CoinAssetBuyAndSellViewModel(asset: portfolioAsset, isBuyViewController: false)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    static func showDetailViewControllerAfterConfirmingTransaction(navigationController: UINavigationController?) {
        guard let prevVC = navigationController?.previousViewController as? CoinAssetDetailViewController else { return }
        prevVC.viewModel?.fetchCoinsPortfolio()
        prevVC.type = .buyAndSellViewController
        navigationController?.popViewController(animated: true)
    }
}
