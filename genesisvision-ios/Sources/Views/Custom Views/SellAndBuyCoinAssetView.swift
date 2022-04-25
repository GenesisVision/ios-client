//
//  SellAndBuyCoinAssetView.swift
//  genesisvision-ios
//
//  Created by Gregory on 04.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class SellAndBuyCoinAssetView: UIView {
    
    @IBOutlet weak var mainLabel: TitleLabel!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var amountValueLabel: TitleLabel!
    
    @IBOutlet weak var amountTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var priceValueLabel: TitleLabel!
    
    @IBOutlet weak var priceTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var change24hValueLabel: TitleLabel!
    
    @IBOutlet weak var change24hTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var totalValueLabel: TitleLabel!
    
    @IBOutlet weak var totalTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var avaragePriceValueLabel: TitleLabel!
    
    @IBOutlet weak var averagePriceTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var profitValueLabel: TitleLabel!
    
    @IBOutlet weak var profitTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var buyButtonLabel: UIButton!
    
    @IBOutlet weak var sellButtonLabel: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        commonSetup()
        setupLabels()
        setupButtons() 
    }
    
    func configure(assetPortfolio: CoinsAsset) {
        mainLabel.text = Constants.CoinAssetsConstants.portfolioLabels.yourInvestments
        amountTitleLabel.text = Constants.CoinAssetsConstants.portfolioLabels.amount
        if let amount = assetPortfolio.amount {
            amountValueLabel.text = amount.toString() + " " + (assetPortfolio.asset ?? "")
        }
        priceTitleLabel.text = Constants.CoinAssetsConstants.portfolioLabels.price
        if let price = assetPortfolio.price {
            priceValueLabel.text = "$ " + price.toString()
        }
        if let change = assetPortfolio.change24Percent {
            change24hValueLabel.text = change.toString() + "%"
            if change < 0 {
                change24hValueLabel.textColor = UIColor.Common.red
            } else if change > 0 {
                change24hValueLabel.textColor = UIColor.Common.green
            }
        }
        change24hTitleLabel.text = Constants.CoinAssetsConstants.portfolioLabels.change24h
        if let total = assetPortfolio.total {
            totalValueLabel.text = "$ " + total.toString()
        }
        totalTitleLabel.text = Constants.CoinAssetsConstants.portfolioLabels.total
        if let avaragePrice = assetPortfolio.averagePrice {
            avaragePriceValueLabel.text = "$ " + avaragePrice.toString()
        }
        averagePriceTitleLabel.text = Constants.CoinAssetsConstants.portfolioLabels.averagePrice
        if let profit = assetPortfolio.profitCurrent {
            var stringProfit = profit.toString()
            if stringProfit.starts(with: "-") {
                stringProfit.removeFirst()
                profitValueLabel.textColor = UIColor.Common.red
            } else {
                profitValueLabel.textColor = UIColor.Common.green
            }
            profitValueLabel.text = "$ " + stringProfit
        }
        profitTitleLabel.text = Constants.CoinAssetsConstants.portfolioLabels.profit
        
    }
    
    private func commonSetup() {
        let className = String(describing: SellAndBuyCoinAssetView.self)
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundColor = UIColor.Common.darkCell
    }
    
    func setupLabels() {
        mainLabel.font = UIFont.getFont(.medium, size: 18)
        mainLabel.textColor = UIColor.Font.primary
        amountValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        priceValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        change24hValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        change24hValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        avaragePriceValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        profitValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        totalValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
    }
    
    func setupButtons() {
        buyButtonLabel.backgroundColor = UIColor.Common.green
        buyButtonLabel.titleLabel?.font = UIFont.getFont(.regular, size: 14.0)
        buyButtonLabel.setTitleColor(UIColor.Cell.title, for: .normal)
        buyButtonLabel.roundCorners()
        sellButtonLabel.backgroundColor = UIColor.Common.red
        sellButtonLabel.titleLabel?.font = UIFont.getFont(.regular, size: 14.0)
        sellButtonLabel.setTitleColor(UIColor.Cell.title, for: .normal)
        sellButtonLabel.roundCorners()
    }
}
