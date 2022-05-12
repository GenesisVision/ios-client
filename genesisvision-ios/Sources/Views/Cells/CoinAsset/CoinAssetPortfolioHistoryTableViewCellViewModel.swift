//
//  CoinAssetPortfolioTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 27.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

struct CoinAssetPortfolioTableViewCellViewModel: CellViewModel {
    let coinAsset: CoinsAsset

    func setup(on cell: CoinAssetTableViewCell) {
        cell.configure(coinAsset, filterProtocol: nil, favoriteProtocol: nil)
    }
}

struct CoinAssetHistoryTableViewCellViewModel: CellViewModel {
    let coinsHistoryEvent: CoinsHistoryEvent
    
    func setup(on cell: CoinAssetTableViewCell) {
        cell.configure(coinsHistoryEvent, filterProtocol: nil, favoriteProtocol: nil)
    }
}
