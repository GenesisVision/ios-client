//
//  FundContentView.swift
//  genesisvision-ios
//
//  Created by George on 29.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class FundContentView: UIStackView {
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
    @IBOutlet weak var managerNameLabel: SubtitleLabel! {
        didSet {
            managerNameLabel.textColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var profitPercentLabel: TitleLabel! {
        didSet {
            profitPercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    @IBOutlet weak var firstStackView: LabelWithTitle!
    @IBOutlet weak var secondStackView: LabelWithTitle!
    @IBOutlet weak var thirdStackView: LabelWithTitle!
    
    //TODO: Move to code: One StackView
    @IBOutlet weak var fundBottomStackView: UIStackView! {
        didSet {
            fundBottomStackView.isHidden = true
        }
    }
    @IBOutlet weak var firstFundAssetView: FundAssetView! {
        didSet {
            firstFundAssetView.isHidden = true
        }
    }
    @IBOutlet weak var secondFundAssetView: FundAssetView! {
        didSet {
            secondFundAssetView.isHidden = true
        }
    }
    @IBOutlet weak var thirdFundAssetView: FundAssetView! {
        didSet {
            thirdFundAssetView.isHidden = true
        }
    }
    @IBOutlet weak var otherFundAssetView: FundAssetView! {
        didSet {
            otherFundAssetView.isHidden = true
        }
    }
    
    
    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let assetId = assetId else { return }
        favoriteProtocol?.didChangeFavoriteState(with: assetId, value: sender.isSelected, request: true)
    }
}
extension FundContentView: ContentViewProtocol {
    /// Fund
    /// - Parameters:
    ///   - asset: FundDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(_ asset: FundDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        self.filterProtocol = filterProtocol
        self.favoriteProtocol = favoriteProtocol
        
        if let assetId = asset._id?.uuidString {
            self.assetId = assetId
        }
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = asset.statistic?.chart {
            chartView.isHidden = false
            viewForChartView.isHidden = chartView.isHidden
            noDataLabel.isHidden = true
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: filterProtocol?.filterDateRangeModel)
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        if let title = asset.title {
            titleLabel.text = title
        }
        
        if let managerName = asset.owner?.username {
            managerNameLabel.text = "by " + managerName
        }
        firstStackView.titleLabel.text = "Balance"
        if let balance = asset.balance, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            firstStackView.valueLabel.text = amount.rounded(with: currency, short: true).toString() + " " + currency.rawValue
        } else {
            firstStackView.valueLabel.text = ""
        }
        
        secondStackView.titleLabel.text = "Investors"
        if let investorsCount = asset.investorsCount {
            secondStackView.valueLabel.text = investorsCount.toString()
        } else {
            secondStackView.valueLabel.text = ""
        }
        
        thirdStackView.titleLabel.text = "D.down"
        if let drawdownPercent = asset.statistic?.drawdown {
            thirdStackView.valueLabel.text = drawdownPercent.rounded(with: .undefined).toString() + "%"
        } else {
            thirdStackView.valueLabel.text = ""
        }
        
        favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.personalDetails?.isFavorite {
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
        
        if let profitPercent = asset.statistic?.profit {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        setupFundBottomView(asset.totalAssetsCount, topFundAssets: asset.topFundAssets)
    }
}
extension FundContentView {
    /// Fund assets
    /// - Parameter asset: FundDetails
    func setupFundBottomView(_ totalAssetsCount: Int?, topFundAssets: [FundAssetPercent]?) {
        guard let totalAssetsCount = totalAssetsCount, totalAssetsCount > 0, let topFundAssets = topFundAssets else { return }
        
        fundBottomStackView.isHidden = false
        
        firstFundAssetView.isHidden = true
        if let logo = topFundAssets[0].logoUrl, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[0].percent {
            firstFundAssetView.isHidden = false
            firstFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            firstFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            firstFundAssetView.assetPercentLabel.text = percent.rounded(with: .undefined).toString() + "%"
        }
        
        secondFundAssetView.isHidden = true
        if totalAssetsCount > 1, let logo = topFundAssets[1].logoUrl, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[1].percent {
            secondFundAssetView.isHidden = false
            secondFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            secondFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            secondFundAssetView.assetPercentLabel.text = percent.rounded(with: .undefined).toString() + "%"
        }
        
        thirdFundAssetView.isHidden = true
        if totalAssetsCount > 2, let logo = topFundAssets[2].logoUrl, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[2].percent {
            thirdFundAssetView.isHidden = false
            thirdFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            thirdFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            thirdFundAssetView.assetPercentLabel.text = percent.rounded(with: .undefined).toString() + "%"
        }
        
        otherFundAssetView.isHidden = true
        if totalAssetsCount > 3 {
            otherFundAssetView.isHidden = false
            otherFundAssetView.assetPercentLabel.text = "+\(totalAssetsCount - 3)"
        }
    }
}
