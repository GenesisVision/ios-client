//
//  ProgramContentView.swift
//  genesisvision-ios
//
//  Created by George on 29.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Charts


class ProgramContentView: UIStackView {
    // MARK: - Variables
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
    
    var assetId: String?
    
    // MARK: - Views
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    
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
    
    @IBOutlet weak var currencyLabel: CurrencyLabel!
    
    @IBOutlet weak var profitPercentLabel: TitleLabel! {
        didSet {
            profitPercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    @IBOutlet weak var periodLeftProgressView: CircularProgressView! {
        didSet {
            periodLeftProgressView.foregroundStrokeColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var firstStackView: LabelWithTitle!
    @IBOutlet weak var secondStackView: LabelWithTitle!
    @IBOutlet weak var thirdStackView: LabelWithTitle!
    
    @IBOutlet weak var tagsBottomStackView: UIStackView! {
        didSet {
            tagsBottomStackView.isHidden = true
        }
    }
    @IBOutlet weak var firstTagLabel: RoundedLabel! {
        didSet {
            firstTagLabel.isHidden = true
        }
    }
    @IBOutlet weak var secondTagLabel: RoundedLabel! {
        didSet {
            secondTagLabel.isHidden = true
        }
    }
    @IBOutlet weak var thirdTagLabel: RoundedLabel! {
        didSet {
            thirdTagLabel.isHidden = true
        }
    }
    @IBOutlet weak var otherTagLabel: RoundedLabel! {
        didSet {
            otherTagLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let assetId = assetId else { return }
        favoriteProtocol?.didChangeFavoriteState(with: assetId, value: sender.isSelected, request: true)
    }
}

extension ProgramContentView: ContentViewProtocol {
    /// Program
    /// - Parameters:
    ///   - asset: ProgramDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(_ asset: ProgramDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
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
        
        assetLogoImageView.levelButton.setImage(nil, for: .normal)
        
        if let levelProgress = asset.levelProgress {
            assetLogoImageView.levelButton.progress = levelProgress
        }
        
        if let level = asset.level {
            assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let currency = asset.currency {
            currencyLabel.text = currency.rawValue
        }
        
        firstStackView.titleLabel.text = "Period"
        if let periodStarts = asset.periodStarts, let periodEnds = asset.periodEnds, let periodDuration = asset.periodDuration {
            firstStackView.valueLabel.text = periodDuration.toString() + (periodDuration > 1 ? " days" : " day")
            
            let today = Date()
            if let periodDuration = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate:periodStarts).minute, let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        } else {
            firstStackView.valueLabel.text = ""
        }
        
        secondStackView.titleLabel.text = "Equity"
        if let balance = asset.balance, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            secondStackView.valueLabel.text = amount.rounded(with: currency, short: true).toString() + " " + currency.rawValue
        } else {
            secondStackView.valueLabel.text = ""
        }
        
        thirdStackView.titleLabel.text = "Av. to invest"
        if let availableInvestment = asset.availableToInvest, let currency = asset.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            thirdStackView.valueLabel.text = availableInvestment.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        } else {
            thirdStackView.valueLabel.text = ""
        }
        
        
        favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.personalDetails?.isFavorite {
            favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = asset.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.statistic?.profit {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        setupTagsBottomView(asset.tags, status: asset.status)
    }
}

extension ProgramContentView {
    /// Program tags
    /// - Parameter asset: ProgramDetails
    func setupTagsBottomView(_ tags: [Tag]?, status: String?) {
        guard var tags = tags, !tags.isEmpty else {
            return
        }
        
        if let status = status, status == "closed" {
            tags.insert(Tag(name: "Closed", color: "#787d82"), at: 0)
        }
        
        let tagsCount = tags.count
        tagsBottomStackView.isHidden = false
        
        firstTagLabel.isHidden = true
        if let name = tags[0].name, let color = tags[0].color {
            firstTagLabel.isHidden = false
            firstTagLabel.text = name.uppercased()
            firstTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            firstTagLabel.textColor = UIColor.hexColor(color)
        }
        
        secondTagLabel.isHidden = true
        if tagsCount > 1, let name = tags[1].name, let color = tags[1].color {
            secondTagLabel.isHidden = false
            secondTagLabel.text = name.uppercased()
            secondTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            secondTagLabel.textColor = UIColor.hexColor(color)
        }
        
        thirdTagLabel.isHidden = true
        if tagsCount > 2, let name = tags[2].name, let color = tags[2].color {
            thirdTagLabel.isHidden = false
            thirdTagLabel.text = name.uppercased()
            thirdTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            thirdTagLabel.textColor = UIColor.hexColor(color)
        }
        
        otherTagLabel.isHidden = true
        if tagsCount > 3 {
            otherTagLabel.isHidden = false
            otherTagLabel.text = "+\(tagsCount - 3)"
            otherTagLabel.backgroundColor = UIColor.Common.green.withAlphaComponent(0.1)
            otherTagLabel.textColor = UIColor.Common.green
        }
    }
}
