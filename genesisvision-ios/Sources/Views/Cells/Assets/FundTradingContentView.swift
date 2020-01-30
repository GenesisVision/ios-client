//
//  FundTradingContentView.swift
//  genesisvision-ios
//
//  Created by George on 29.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class FundTradingContentView: UIStackView {
    // MARK: - Variables
    weak var filterProtocol: FilterChangedProtocol?
    
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
    
    @IBOutlet weak var viewForChartView: UIView!
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var noDataLabel: SubtitleLabel!
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var assetTypeLabel: SubtitleLabel! {
        didSet {
            assetTypeLabel.textColor = UIColor.primary
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
}

extension FundTradingContentView: ContentViewProtocol {
    /// DashboardTrading
    /// - Parameters:
    ///   - asset: DashboardTradingAsset
    func configure(fundTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {
        self.filterProtocol = filterProtocol
        if let assetId = asset.id?.uuidString {
            self.assetId = assetId
        }
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let assetType = asset.assetTypeExt {
            switch assetType {
            case .fund:
                assetTypeLabel.text = "Fund"
            default:
                assetTypeLabel.text = assetType.rawValue
            }
        }
        
        if let color = asset.publicInfo?.color {
            photoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let title = asset.publicInfo?.title {
            titleLabel.text = title
        } else if let title = asset.accountInfo?.title {
            titleLabel.text = title
        }
        
        photoImageView.image = UIImage.fundPlaceholder
        if let logo = asset.publicInfo?.logo, let fileUrl = getFileURL(fileName: logo) {
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            photoImageView.backgroundColor = .clear
        }
        
        if let chart = asset.statistic?.chart {
            chartView.isHidden = false
            viewForChartView.isHidden = chartView.isHidden
            noDataLabel.isHidden = true
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: filterProtocol?.filterDateRangeModel)
        }
        
        if let profitPercent = asset.statistic?.profit {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        firstStackView.titleLabel.text = "Equity"
        if let amount = asset.accountInfo?.balance, let balanceCurrency = asset.accountInfo?.currency, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            firstStackView.valueLabel.text = amount.rounded(with: currency, short: true).toString() + " " + currency.rawValue
        } else {
            firstStackView.valueLabel.text = ""
        }
        
        secondStackView.titleLabel.text = "D.down"
        if let drawdown = asset.statistic?.drawdown {
            secondStackView.valueLabel.text = drawdown.toString()
        } else {
            secondStackView.valueLabel.text = "0"
        }
        
        thirdStackView.titleLabel.text = "Age"
        if let creationDate = asset.accountInfo?.creationDate {
            let duration = Date().daysSinceDate(fromDate: creationDate)
            thirdStackView.valueLabel.text = duration
        } else {
            thirdStackView.valueLabel.text = ""
        }
        
        if let type = asset.accountInfo?.type, type == .externalTradingAccount {
            firstStackView.isHidden = true
        }
        
        setupFundBottomView(asset.publicInfo?.fundDetails?.totalAssetsCount, topFundAssets: asset.publicInfo?.fundDetails?.topFundAssets)
    }
}

extension FundTradingContentView {
    /// Fund assets
    /// - Parameter asset: FundDetails
    func setupFundBottomView(_ totalAssetsCount: Int?, topFundAssets: [FundAssetPercent]?) {
        guard let totalAssetsCount = totalAssetsCount, totalAssetsCount > 0, let topFundAssets = topFundAssets else { return }
        
        fundBottomStackView.isHidden = false
        
        firstFundAssetView.isHidden = true
        if let logo = topFundAssets[0].icon, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[0].percent {
            firstFundAssetView.isHidden = false
            firstFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            firstFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            firstFundAssetView.assetPercentLabel.text = percent.rounded(with: .undefined).toString() + "%"
        }
        
        secondFundAssetView.isHidden = true
        if totalAssetsCount > 1, let logo = topFundAssets[1].icon, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[1].percent {
            secondFundAssetView.isHidden = false
            secondFundAssetView.assetLogoImageView.kf.indicatorType = .activity
            secondFundAssetView.assetLogoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            
            secondFundAssetView.assetPercentLabel.text = percent.rounded(with: .undefined).toString() + "%"
        }
        
        thirdFundAssetView.isHidden = true
        if totalAssetsCount > 2, let logo = topFundAssets[2].icon, let fileUrl = getFileURL(fileName: logo), let percent = topFundAssets[2].percent {
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
