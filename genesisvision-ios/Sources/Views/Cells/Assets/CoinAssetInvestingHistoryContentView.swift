//
//  CoinAssetInvestingHistoryContentView.swift
//  genesisvision-ios
//
//  Created by Gregory on 05.05.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetInvestingHistoryContentView: UIStackView {
    // MARK: - Variables
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromLabel: SubtitleLabel!
    @IBOutlet weak var fromIconImage: UIImageView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var toLabel: SubtitleLabel!
    @IBOutlet weak var toIconImage: UIImageView!
    @IBOutlet weak var priceLabel: SubtitleLabel!
    @IBOutlet weak var commissionLabel: SubtitleLabel!
}


extension CoinAssetInvestingHistoryContentView: ContentViewProtocol {
    func configure(_ asset: CoinsHistoryEvent, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        guard let coinTrade = asset.trade else { return }
        
        if let date = coinTrade.date {
            dateLabel.text = date.dateAndTimeFormatString
        }
        if let soldAmount = coinTrade.soldAmount?.toString(), let soldAsset = coinTrade.soldAsset?.asset {
            fromLabel.text = soldAmount + " " + soldAsset
        }
        if let boughtAmount = coinTrade.boughtAmount?.toString(), let boughtAsset = coinTrade.boughtAsset?.asset {
            toLabel.text = boughtAmount + " " + boughtAsset
        }
        if let price = coinTrade.price {
            priceLabel.text = "Price" + " $ " + price.toString()
        }
        if let commission = coinTrade.commission, let currency = coinTrade.commissionCurrency {
            commissionLabel.text = "Commission" + " " + commission.toString() + " " + currency
        }
        if let fileName = coinTrade.soldAsset?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            fromIconImage.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
        if let fileName = coinTrade.boughtAsset?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            toIconImage.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
        arrowIcon.image = UIImage(named: "arrow.down")
        
        fromLabel.textColor = .white
        toLabel.textColor = .white
        dateLabel.font = UIFont.getFont(.bold, size: 14)
        dateLabel.textColor = .white
    }
}
