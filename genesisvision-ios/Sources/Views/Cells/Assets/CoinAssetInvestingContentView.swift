//
//  CoinAssetInvestingContentView.swift
//  genesisvision-ios
//
//  Created by Gregory on 15.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetInvestingContentView: UIStackView {
    // MARK: - Variables
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: TitleLabel!
    @IBOutlet weak var amountAndSymbolLabel: SubtitleLabel!
    @IBOutlet weak var priceLabel: TitleLabel!
    @IBOutlet weak var profitLabel: SubtitleLabel!
    @IBOutlet weak var changeLabel: SubtitleLabel!
    
}

extension CoinAssetInvestingContentView: ContentViewProtocol {
    func configure(_ asset: CoinsAsset, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        self.filterProtocol = filterProtocol
        self.favoriteProtocol = favoriteProtocol
        
        if let name = asset.name {
            nameLabel.text = name
        }
        if let amount = asset.amount, let symbol = asset.asset {
            amountAndSymbolLabel.text = amount.toString() + " " + symbol
        }
        if let price = asset.price, let average = asset.averagePrice {
            priceLabel.text = "$ \(price) (avg. \(average))"
        }
        if let total = asset.total, let profit = asset.profitCurrent {
            if profit.toString().starts(with: "-") {
                var profitString = profit.toString()
                profitString.removeFirst()
                profitLabel.text = "$ \(total) (- $ \(profitString))"
                profitLabel.textColor = UIColor.Common.red
            } else {
                profitLabel.text = "$ \(total) ($ \(profit))"
                profitLabel.textColor = UIColor.Common.green
            }
        }
        if let change = asset.change24Percent {
            if change.toString().starts(with: "-") {
                var changeString = change.toString()
                changeString.removeFirst()
                changeLabel.textColor = UIColor.Common.red
            } else {
                changeLabel.textColor = UIColor.Common.green
            }
            changeLabel.text = "\(change)% (24h)"
        }
        if let logo = asset.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            self.logoImageView.kf.setImage(with: fileUrl)
        }
    }
}




