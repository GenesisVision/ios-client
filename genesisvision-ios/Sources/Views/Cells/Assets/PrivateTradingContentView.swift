//
//  PrivateTradingContentView.swift
//  genesisvision-ios
//
//  Created by George on 29.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class PrivateTradingContentView: UIStackView {
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
}
extension PrivateTradingContentView: ContentViewProtocol {
    /// DashboardTrading
    /// - Parameters:
    ///   - asset: DashboardTradingAsset
    func configure(_ asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {
        self.filterProtocol = filterProtocol
        if let assetId = asset.id?.uuidString {
            self.assetId = assetId
        }
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let assetType = asset.assetType?.rawValue {
            assetTypeLabel.text = assetType
        }
        
        // MARK: - Public Info
        if let color = asset.publicInfo?.color {
            photoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let title = asset.publicInfo?.title {
            titleLabel.text = title
        } else if let title = asset.accountInfo?.title {
            titleLabel.text = title
        }
        
        if let assetType = asset.accountInfo?.type {
            switch assetType {
            case .tradingAccount:
                assetTypeLabel.text = "Trading account"
            case .externalTradingAccount:
                assetTypeLabel.text = "External trading account"
            default:
                assetTypeLabel.text = assetType.rawValue
            }
        }
        
        if let title = asset.accountInfo?.login {
            titleLabel.text = title
        }
        
        if let logo = asset.broker?.logo, let fileUrl = getFileURL(fileName: logo) {
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: fileUrl)
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
        
        secondStackView.titleLabel.text = "Leverage"
        if let leverage = asset.accountInfo?.leverage {
            secondStackView.valueLabel.text = "1:" + leverage.toString()
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
    }
}
