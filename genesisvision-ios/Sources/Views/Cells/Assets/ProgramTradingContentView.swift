//
//  ProgramTradingContentView.swift
//  genesisvision-ios
//
//  Created by George on 29.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Charts


class ProgramTradingContentView: UIStackView {
    // MARK: - Variables
    weak var filterProtocol: FilterChangedProtocol?
    
    var assetId: String?
    
    // MARK: - Views
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    
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
    
    @IBOutlet weak var currencyLabel: CurrencyLabel!
    
    @IBOutlet weak var profitPercentLabel: TitleLabel! {
        didSet {
            profitPercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    @IBOutlet weak var firstStackView: LabelWithTitle!
    @IBOutlet weak var secondStackView: LabelWithTitle!
    @IBOutlet weak var thirdStackView: LabelWithTitle!
    
    @IBOutlet weak var brokerStackView: LabelWithTitle!
    @IBOutlet weak var loginStackView: LabelWithTitle!
}
extension ProgramTradingContentView: ContentViewProtocol {
    /// DashboardTrading
    /// - Parameters:
    ///   - asset: DashboardTradingAsset
    func configure(programTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {
        self.filterProtocol = filterProtocol
        
        if let assetId = asset._id?.uuidString {
            self.assetId = assetId
        }
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        currencyLabel.isHidden = true
        
        assetLogoImageView.levelButton.isHidden = true
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let assetType = asset.assetTypeExt {
            switch assetType {
            case .program:
                assetTypeLabel.text = "Program"
            case .signalProgram:
                assetTypeLabel.text = "Signal program"
            default:
                assetTypeLabel.text = assetType.rawValue
            }
        }
        
        if let color = asset.publicInfo?.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let title = asset.publicInfo?.title {
            titleLabel.text = title
        } else if let title = asset.accountInfo?.title {
            titleLabel.text = title
        }
        
        assetLogoImageView.levelButton.setImage(nil, for: .normal)
        assetLogoImageView.levelButton.isHidden = false
        if let levelProgress = asset.publicInfo?.programDetails?.levelProgress {
            assetLogoImageView.levelButton.progress = levelProgress
        }
        
        if let level = asset.publicInfo?.programDetails?.level {
            assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        if let logo = asset.publicInfo?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
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
            secondStackView.valueLabel.text = drawdown.rounded(toPlaces: 2).toString()
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
        
        if let name = asset.broker?.name {
            brokerStackView.isHidden = false
            brokerStackView.titleLabel.text = "Broker"
            brokerStackView.valueLabel.text = name
        }
        
        if let login = asset.accountInfo?.login {
            loginStackView.isHidden = false
            loginStackView.titleLabel.text = "Login"
            loginStackView.valueLabel.text = login
        }
        
        if let type = asset.accountInfo?.type, type == .externalTradingAccount {
            firstStackView.isHidden = true
        }
    }
}
