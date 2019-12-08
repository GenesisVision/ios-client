//
//  ProgramTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class RoundedBackgroundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white.withAlphaComponent(0.02)
        roundCorners(with: 8)
    }
}
    
class FundAssetView: RoundedBackgroundView {
    @IBOutlet weak var assetLogoImageView: UIImageView! {
        didSet {
            assetLogoImageView.roundCorners()
        }
    }
    @IBOutlet weak var assetPercentLabel: TitleLabel!
}

class ProgramContentView: UIStackView {
    // MARK: - Variables
    weak var delegate: FavoriteStateChangeProtocol?
    weak var reinvestProtocol: SwitchProtocol?
    
    var assetId: String?
    
    // MARK: - Views
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    @IBOutlet weak var reinvestStackView: UIStackView!

    @IBOutlet weak var ratingLabel: RoundedLabel! {
        didSet {
            ratingLabel.isHidden = true
            ratingLabel.textColor = UIColor.Cell.subtitle
            ratingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.14)
        }
    }
    
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    @IBOutlet weak var viewForChartView: UIView!
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var investedImageView: UIImageView! {
        didSet {
            investedImageView.isHidden = true
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
    @IBOutlet weak var profitValueLabel: SubtitleLabel!
    
    @IBOutlet weak var periodLeftProgressView: CircularProgressView! {
        didSet {
            periodLeftProgressView.foregroundStrokeColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var firstValueLabel: TitleLabel!
    @IBOutlet weak var secondValueLabel: TitleLabel!
    @IBOutlet weak var thirdValueLabel: TitleLabel!
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel!
    @IBOutlet weak var secondTitleLabel: SubtitleLabel!
    @IBOutlet weak var thirdTitleLabel: SubtitleLabel!
    
    
    @IBOutlet weak var dashboardBottomStackView: UIStackView! {
        didSet {
            dashboardBottomStackView.isHidden = true
        }
    }
    
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
    
    @IBOutlet weak var statusButton: StatusButton!
    @IBOutlet weak var reinvestSwitch: UISwitch! {
        didSet {
            reinvestSwitch.onTintColor = UIColor.primary
            reinvestSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            reinvestSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var reinvestLabel: TitleLabel! {
        didSet {
            reinvestLabel.font = UIFont.getFont(.semibold, size: 12.0)
            reinvestLabel.text = "Reinvest profit"
        }
    }
    @IBOutlet weak var reinvestTooltip: TooltipButton! {
        didSet {
            reinvestTooltip.tooltipText = "Reinvest Tooltip"
            reinvestTooltip.isHidden = true
        }
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let assetId = assetId else { return }
        delegate?.didChangeFavoriteState(with: assetId, value: sender.isSelected, request: true)
    }
    
    @IBAction func reinvestSwitchAction(_ sender: UISwitch) {
        if let assetId = assetId {
            reinvestProtocol?.didChangeSwitch(value: sender.isOn, assetId: assetId)
        }
    }
    
}

extension ProgramContentView {
    /// Fund
    /// - Parameters:
    ///   - asset: FundDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(fund asset: FundDetails, delegate: FavoriteStateChangeProtocol?) {
        self.delegate = delegate
        if let assetId = asset.id?.uuidString {
            self.assetId = assetId
        }
        
        setupFundBottomView(asset)
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = asset.chart {
            chartView.isHidden = false
            viewForChartView.isHidden = chartView.isHidden
            noDataLabel.isHidden = true
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        if let title = asset.title {
            titleLabel.text = title
        }
        
        if let managerName = asset.manager?.username {
            managerNameLabel.text = "by " + managerName
        }
        
        assetLogoImageView.levelButton.isHidden = true
        currencyLabel.isHidden = true
        
        periodLeftProgressView.isHidden = true
        
        firstTitleLabel.text = "Balance"
        if let balance = asset.statistic?.balanceGVT, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            firstValueLabel.text = amount.rounded(with: currency, short: true).toString() + " " + currency.rawValue
        } else {
            firstValueLabel.text = ""
        }
        
        
        secondTitleLabel.text = "Investors"
        if let investorsCount = asset.statistic?.investorsCount {
            secondValueLabel.text = investorsCount.toString()
        } else {
            secondValueLabel.text = ""
        }
        
        thirdTitleLabel.text = "D.down"
        if let drawdownPercent = asset.statistic?.drawdownPercent {
            thirdValueLabel.text = drawdownPercent.rounded(with: .undefined).toString() + "%"
        } else {
            thirdValueLabel.text = ""
        }
        
        
        favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.personalDetails?.isFavorite {
            favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.fundPlaceholder
        
        if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        profitValueLabel.isHidden = true
        
        if let isInvested = asset.personalDetails?.isInvested {
            investedImageView.isHidden = !isInvested
        }
    }
    
    /// Program
    /// - Parameters:
    ///   - asset: ProgramDetails
    ///   - delegate: FavoriteStateChangeProtocol
    ///   - isRating: Bool
    func configure(program asset: ProgramDetails, delegate: FavoriteStateChangeProtocol?, isRating: Bool) {
        self.delegate = delegate
        if let assetId = asset.id?.uuidString {
            self.assetId = assetId
        }
        
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let chart = asset.chart {
            chartView.isHidden = false
            viewForChartView.isHidden = chartView.isHidden
            noDataLabel.isHidden = true
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        if let title = asset.title {
            titleLabel.text = title
        }
        
        if let managerName = asset.manager?.username {
            managerNameLabel.text = "by " + managerName
        }
        
        
        
        assetLogoImageView.levelButton.setImage(nil, for: .normal)
        assetLogoImageView.levelButton.setTitle(nil, for: .normal)
        
        if let levelProgress = asset.levelProgress {
            assetLogoImageView.levelButton.progress = levelProgress
        }
        
        if let level = asset.level {
            if isRating, let rating = asset.rating, let canLevelUp = rating.canLevelUp, canLevelUp {
                assetLogoImageView.levelButton.setImage(#imageLiteral(resourceName: "img_arrow_up_rating"), for: .normal)
                assetLogoImageView.levelButton.backgroundColor = UIColor.Level.color(for: level)
            } else {
                assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
            }
        }
        
        ratingLabel.isHidden = !isRating
        
        if isRating, let rating = asset.rating, let ratingPlace = rating.rating {
            ratingLabel.text = ratingPlace.toString()
        }
        
        if let currency = asset.currency {
            currencyLabel.text = currency.rawValue
        }
        
        firstTitleLabel.text = "Period"
        if let periodStarts = asset.periodStarts, let periodEnds = asset.periodEnds, let periodDuration = asset.periodDuration {
            firstValueLabel.text = periodDuration.toString() + (periodDuration > 1 ? " days" : " day")
            
            let today = Date()
            if let periodDuration = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate:periodStarts).minute, let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        } else {
            firstValueLabel.text = ""
        }
        
        
        secondTitleLabel.text = "Equity"
        if let balance = asset.statistic?.balanceBase, let balanceCurrency = balance.currency, let amount = balance.amount, let currency = CurrencyType(rawValue: balanceCurrency.rawValue) {
            secondValueLabel.text = amount.rounded(with: currency, short: true).toString() + " " + currency.rawValue
        } else {
            secondValueLabel.text = ""
        }
        
        thirdTitleLabel.text = "Av. to invest"
        if let availableInvestment = asset.availableInvestmentBase, let currency = asset.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            thirdValueLabel.text = availableInvestment.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        } else {
            thirdValueLabel.text = ""
        }
        
        
        favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.personalDetails?.isFavorite {
            favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let status = asset.status, status == .closed {
            reinvestStackView.isHidden = true
            dashboardBottomStackView.isHidden = false
            statusButton.handleUserInteractionEnabled = false
            statusButton.setTitle(status.rawValue, for: .normal)
            statusButton.layoutSubviews()
        }
        
        if let profitPercent = asset.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        profitValueLabel.isHidden = true
        
        if let isInvested = asset.personalDetails?.isInvested {
            investedImageView.isHidden = !isInvested
        }
    }
    
    /// Dashboard program
    /// - Parameters:
    ///   - asset: ProgramDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(dashboardProgram asset: ProgramDetails, delegate: FavoriteStateChangeProtocol?, reinvestProtocol: SwitchProtocol?) {
        self.delegate = delegate
        self.reinvestProtocol = reinvestProtocol
        if let assetId = asset.id?.uuidString {
            self.assetId = assetId
        }
        
        dashboardBottomStackView.isHidden = false
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText
        
        if let isReinvesting = asset.personalDetails?.isReinvest {
            reinvestSwitch.isOn = isReinvesting
        }
        
        if let chart = asset.chart {
            chartView.isHidden = false
            viewForChartView.isHidden = chartView.isHidden
            noDataLabel.isHidden = true
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        if let title = asset.title {
            titleLabel.text = title
        }
        
        if let managerName = asset.manager?.username {
            managerNameLabel.text = "by " + managerName
        }
        
        if let status = asset.personalDetails?.status {
            reinvestStackView.isHidden = status == .ended
            statusButton.handleUserInteractionEnabled = false
            statusButton.setTitle(status.rawValue, for: .normal)
            statusButton.layoutSubviews()
        }
        
        if let level = asset.level {
            assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let levelProgress = asset.levelProgress {
            assetLogoImageView.levelButton.progress = levelProgress
        }
        
        if let currency = asset.currency {
            currencyLabel.text = currency.rawValue
        }
        
        firstTitleLabel.text = "time left"
        if let periodEnds = asset.periodEnds, let periodDuration = asset.periodDuration {
            
            let today = Date()
            let periodLeft = periodEnds.daysSinceDate(fromDate: today)
            
            firstValueLabel.text = periodLeft.isEmpty ? "0" : periodLeft
            
            if let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                periodLeftProgressView.setProgress(to: Double(periodDuration - minutes) / Double(periodDuration), withAnimation: false)
            }
        } else {
            firstValueLabel.text = ""
        }
        
        secondTitleLabel.text = "current value"
        if let value = asset.personalDetails?.value, let currency = asset.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            
            secondValueLabel.text = value.rounded(with: currencyType, short: true).toString() + " " + currencyType.rawValue
        } else {
            secondValueLabel.text = ""
        }
        
        thirdTitleLabel.text = "share"
        if let share = asset.dashboardAssetsDetails?.share {
            thirdValueLabel.text = share.rounded(with: .undefined).toString() + "%"
        } else {
            thirdValueLabel.text = ""
        }
        
        if let isFavorite = asset.personalDetails?.isFavorite {
            favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        profitValueLabel.isHidden = true
        
        if let isInvested = asset.personalDetails?.isInvested {
            investedImageView.isHidden = !isInvested
        }
    }
    
    /// Dashboard fund
    /// - Parameters:
    ///   - asset: FundDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(dashboardFund asset: FundDetails, delegate: FavoriteStateChangeProtocol?) {
        self.delegate = delegate
        if let assetId = asset.id?.uuidString {
            self.assetId = assetId
        }
        
        setupFundBottomView(asset)
        
        fundBottomStackView.isHidden = true
        chartView.isHidden = true
        noDataLabel.isHidden = false
        viewForChartView.isHidden = chartView.isHidden
        
        noDataLabel.text = String.Alerts.ErrorMessages.noDataText

        if let chart = asset.chart {
            chartView.isHidden = false
            noDataLabel.isHidden = true
            viewForChartView.isHidden = chartView.isHidden
            chartView.setup(chartType: .default, lineChartData: chart, dateRangeModel: delegate?.filterDateRangeModel)
        }
        
        spacing = chartView.isHidden ? 24 : 8
        
        if let title = asset.title {
            titleLabel.text = title
        }
        
        if let managerName = asset.manager?.username {
            managerNameLabel.text = "by " + managerName
        }
        
        assetLogoImageView.levelButton.isHidden = true
        currencyLabel.isHidden = true
        
        periodLeftProgressView.isHidden = true
        
        firstTitleLabel.text = "current value"
        if let value = asset.personalDetails?.value {
            let currency: CurrencyType = .gvt
            firstValueLabel.text = value.rounded(with: currency).toString() + " " + currency.rawValue
        } else {
            firstValueLabel.text = ""
        }
        
        secondStackView.isHidden = true
        
        thirdTitleLabel.text = "d.down"
        if let drawdownPercent = asset.statistic?.drawdownPercent {
            thirdValueLabel.text = drawdownPercent.rounded(with: .undefined).toString() + "%"
        } else {
            thirdValueLabel.text = ""
        }
        
        
        favoriteButton.isHidden = !AuthManager.isLogin()
        
        if let isFavorite = asset.personalDetails?.isFavorite {
            favoriteButton.isSelected = isFavorite
        }
        
        if let color = asset.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.fundPlaceholder
        
        if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = asset.statistic?.profitPercent {
            let sign = profitPercent > 0 ? "+" : ""
            profitPercentLabel.text = sign + profitPercent.rounded(with: .undefined).toString() + "%"
            profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        profitValueLabel.isHidden = true
        
        if let isInvested = asset.personalDetails?.isInvested {
            investedImageView.isHidden = !isInvested
        }
    }
    
    /// Fund assets
    /// - Parameter asset: FundDetails
    func setupFundBottomView(_ asset: FundDetails) {
        guard let totalAssetsCount = asset.totalAssetsCount, totalAssetsCount > 0, let topFundAssets = asset.topFundAssets else { return }
        
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
    
    /// Program tags
    /// - Parameter asset: ProgramDetails
    func setupTagsBottomView(_ asset: ProgramDetails) {
        guard var tags = asset.tags, !tags.isEmpty else {
            return
        }
        
        if let status = asset.status, status == .closed {
            tags.insert(ProgramTag(name: "Closed", color: "#787d82"), at: 0)
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

class ProgramTableViewCell: PlateTableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var stackView: UIStackView!
    
    var cellContentView: ProgramContentView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgColor = UIColor.Cell.bg
    }
    
    func loadContentView() {
        stackView.removeAllArrangedSubviews()
        cellContentView = ProgramContentView.viewFromNib()
        stackView.addArrangedSubview(cellContentView)
    }
    
    // MARK: - Public methods
    /// Fund
    /// - Parameters:
    ///   - asset: FundDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(fund asset: FundDetails, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(fund: asset, delegate: delegate)
    }
    
    /// Program
    /// - Parameters:
    ///   - asset: ProgramDetails
    ///   - delegate: FavoriteStateChangeProtocol
    ///   - isRating: isRating
    func configure(program asset: ProgramDetails, delegate: FavoriteStateChangeProtocol?, isRating: Bool) {
        loadContentView()
        
        cellContentView.configure(program: asset, delegate: delegate, isRating: isRating)
        
        bgColor = UIColor.Cell.bg
        
        if asset.level != nil, isRating, let rating = asset.rating, let canLevelUp = rating.canLevelUp, canLevelUp {
                bgColor = UIColor.Cell.ratingBg
        }
    }
    
    /// Dashboard program
    /// - Parameters:
    ///   - asset: ProgramDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(dashboardProgram asset: ProgramDetails, delegate: FavoriteStateChangeProtocol?, reinvestProtocol: SwitchProtocol?) {
        loadContentView()
        cellContentView.configure(dashboardProgram: asset, delegate: delegate, reinvestProtocol: reinvestProtocol)
    }
    
    /// Dashboard fund
    /// - Parameters:
    ///   - asset: FundDetails
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(dashboardFund asset: FundDetails, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(dashboardFund: asset, delegate: delegate)
    }
}
