//
//  CoinAssetContentView.swift
//  genesisvision-ios
//
//  Created by Gregory on 15.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit
import Charts


class CoinAssetContentView: UIStackView {
    // MARK: - Variables
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
    
    var assetId: String?
    
    // MARK: - Views
    
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.clipsToBounds = true
            photoImageView.image = UIImage.profilePlaceholder
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.roundCorners(with: 6.0)
        }
    }
    
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    @IBOutlet weak var viewForChartView: UIView!
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var noDataLabel: SubtitleLabel!
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var coinSymbolLabel: SubtitleLabel! {
        didSet {
            coinSymbolLabel.textColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var priceLabel: TitleLabel!
    
    @IBOutlet weak var profitPercentLabel: TitleLabel! {
        didSet {
            profitPercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    @IBOutlet weak var firstStackView: LabelWithTitle!
    @IBOutlet weak var secondStackView: LabelWithTitle!
    
    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let assetId = assetId else { return }
        favoriteProtocol?.didChangeFavoriteState(with: assetId, value: sender.isSelected, request: true)
    }
}

// MARK: - TODO Remove all constants!
extension CoinAssetContentView: ContentViewProtocol {
    
    func configure(_ asset: CoinsAsset, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        self.filterProtocol = filterProtocol
        self.favoriteProtocol = favoriteProtocol
        
        if let assetId = asset._id?.uuidString {
            self.assetId = assetId
        }
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = asset.chart?.chart {
            chartView.isHidden = false
            viewForChartView.isHidden = chartView.isHidden
            noDataLabel.isHidden = true
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: filterProtocol?.filterDateRangeModel)
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        if let title = asset.name {
            titleLabel.text = title
        }
        
        if let symbol = asset.details?.symbol {
            coinSymbolLabel.text = "by " + symbol
        }
        firstStackView.titleLabel.text = "Market Cap"
        if let marketCap = asset.marketCap {
            firstStackView.valueLabel.text = "$" + " " + marketCap.toString()
        } else {
            firstStackView.valueLabel.text = ""
        }
        
        secondStackView.titleLabel.text = "Volume 24h"
        if let volume = asset.totalVolume {
            secondStackView.valueLabel.text = volume.toString()
        } else {
            secondStackView.valueLabel.text = ""
        }
        
        favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.isFavorite {
            favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            photoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        photoImageView.image = UIImage.fundPlaceholder
        
        if let logo = asset.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            photoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.change24Percent {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        if let price = asset.price {
            priceLabel.text = "$" + " " + price.toString()
        }
    }
}
