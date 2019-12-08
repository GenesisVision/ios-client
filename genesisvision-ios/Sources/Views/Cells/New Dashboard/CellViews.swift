//
//  CellViews.swift
//  genesisvision-ios
//
//  Created by George on 28.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol ModalViewProtocol {
    func action()
}

class ActionStackView: UIStackView {
    @IBOutlet weak var actionButton: ActionButton!
    
    var action: () -> Void = {
        
    }
    
    // MARK: - IBAction
    @IBAction func actionButtonAction(_ sender: UIButton) {
        self.action()
    }
}
class AttachStackView: ActionStackView {
    @IBOutlet weak var exchangeTitle: LargeTitleLabel!
    @IBOutlet weak var exchangeView: SelectStackView!
    
    @IBOutlet weak var apiTitle: LargeTitleLabel!
    @IBOutlet weak var apiKeyView: TextFieldStackView!
    @IBOutlet weak var apiSecretView: TextFieldStackView!
    
    func configure(_ action: @escaping () -> Void) {
        self.action = action
        
        exchangeTitle.text = "Exchange"
        exchangeView.titleLabel.text = "Exhange"
        exchangeView.textLabel.text = "Binance"
        exchangeView.selectButton.isEnabled = true
        
        apiTitle.text = "API"
        apiKeyView.titleLabel.text = "Api key"
        apiKeyView.textField.text = ""
        
        apiSecretView.titleLabel.text = "Api secret"
        apiSecretView.textField.text = ""
    }
}
class SelectBrokerStackView: UIStackView {
    @IBOutlet weak var selectBrokerTitle: LargeTitleLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    func configure(_ viewModel: CreateAccountViewModel) {
        selectBrokerTitle.text = viewModel.brokerCollectionViewModel.title
        setupCollectionView(viewModel.brokerCollectionDataSource,
                            viewModel.brokerCollectionDataSource,
                            cellModelsForRegistration: viewModel.brokerCollectionViewModel.cellModelsForRegistration,
                            layout: viewModel.brokerCollectionViewModel.makeLayout())
        
        collectionHeightConstraint.constant = viewModel.brokerCollectionViewModel.getCollectionViewHeight()
    }
    
    func setupCollectionView(_ collectionViewDelegate: UICollectionViewDelegate,
                   _ collectionViewDataSource: UICollectionViewDataSource,
                   cellModelsForRegistration: [CellViewAnyModel.Type],
                   layout: UICollectionViewLayout) {
        collectionView.collectionViewLayout = layout
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDataSource
        
        collectionView.isPagingEnabled = false
        
        collectionView.backgroundColor = UIColor.BaseView.bg

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.indicatorStyle = .black
        
        collectionView.registerNibs(for: cellModelsForRegistration)
        collectionView.reloadData()
    }
}
class SelectedAssetsStackView: UIStackView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    func configure(_ viewModel: CreateFundViewModel) {
        setupCollectionView(viewModel.assetCollectionDataSource,
                            viewModel.assetCollectionDataSource,
                            cellModelsForRegistration: viewModel.assetCollectionViewModel.cellModelsForRegistration,
                            layout: viewModel.assetCollectionViewModel.makeLayout())
        
        collectionHeightConstraint.constant = viewModel.assetCollectionViewModel.getCollectionViewHeight()
    }
    
    func setupCollectionView(_ collectionViewDelegate: UICollectionViewDelegate,
                   _ collectionViewDataSource: UICollectionViewDataSource,
                   cellModelsForRegistration: [CellViewAnyModel.Type],
                   layout: UICollectionViewLayout) {
        collectionView.collectionViewLayout = layout
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDataSource
        
        collectionView.isPagingEnabled = false
        
        collectionView.backgroundColor = UIColor.BaseView.bg

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.indicatorStyle = .black
        
        collectionView.registerNibs(for: cellModelsForRegistration)
        collectionView.reloadData()
    }
}
class CreateAccountStackView: UIStackView {
    @IBOutlet weak var selectBrokerView: SelectBrokerStackView!
    @IBOutlet weak var mainSettingsTitle: LargeTitleLabel!
    
    @IBOutlet weak var accountTypeView: SelectStackView!
    @IBOutlet weak var currencyView: SelectStackView!
    @IBOutlet weak var leverageView: SelectStackView!
    
    @IBOutlet weak var depositTitle: LargeTitleLabel!
    @IBOutlet weak var fromView: SelectStackView!
    @IBOutlet weak var amountView: TextFieldStackView!
    
    @IBOutlet weak var actionButton: ActionButton!
    
    func configure(_ viewModel: CreateAccountViewModel) {
        selectBrokerView.configure(viewModel)
        
        mainSettingsTitle.text = "Main settings"
        
        accountTypeView.titleLabel.text = "Exhange"
        accountTypeView.textLabel.text = "MetaTrader5"
        accountTypeView.selectButton.isEnabled = true
        
        currencyView.titleLabel.text = "Currency"
        currencyView.textLabel.text = "BTC"
        currencyView.selectButton.isEnabled = true
        
        leverageView.titleLabel.text = "Broker's leverage"
        leverageView.textLabel.text = "1"
        leverageView.selectButton.isEnabled = true
        
        depositTitle.text = "Deposit details"
        fromView.titleLabel.text = "From"
        fromView.textLabel.text = "Bitcoin | BTC"
        fromView.selectButton.isEnabled = true
        
        amountView.titleLabel.text = "Amount"
        amountView.textField.text = ""
    }
}
class CreateFundStackView: UIStackView {
    @IBOutlet weak var mainSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var nameView: TextFieldStackView!
    @IBOutlet weak var descriptionView: TextViewStackView!
    @IBOutlet weak var uploadLogoView: ImageViewStackView!
    
    @IBOutlet weak var assetSelectionTitle: LargeTitleLabel!
    @IBOutlet weak var progressView: MultiProgressView! {
        didSet {
            progressView.trackBackgroundColor = UIColor.Cell.subtitle
            progressView.lineCap = .round
            progressView.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var assetStackView: SelectedAssetsStackView!
    
    @IBOutlet weak var feesSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var entryFeeView: TextFieldStackView!
    @IBOutlet weak var exitFeeView: TextFieldStackView!
    
    @IBOutlet weak var depositTitle: LargeTitleLabel!
    @IBOutlet weak var fromView: SelectStackView!
    @IBOutlet weak var amountView: TextFieldStackView!
    
    @IBOutlet weak var actionButton: ActionButton!
    
    var viewModel: CreateFundViewModel?
    
    func configure(_ viewModel: CreateFundViewModel) {
        self.viewModel = viewModel
        
        mainSettingsTitle.text = "Main settings"
        nameView.titleLabel.text = "Name"
        nameView.textField.text = ""
        nameView.subtitleLabel.text = "Requirement from 4 to 20 symbols"
        
        descriptionView.titleLabel.text = "Description"
        descriptionView.textView.text = ""
        descriptionView.subtitleLabel.text = "Requirement from 20 to 500 symbols"
        
        uploadLogoView.logoStackView.isHidden = true
        
        progressView.dataSource = self
        
        assetSelectionTitle.text = viewModel.assetCollectionViewModel.title
        assetStackView.configure(viewModel)
        
        feesSettingsTitle.text = "Fees settings"
        entryFeeView.titleLabel.text = "Entry fee"
        entryFeeView.textField.text = ""
        entryFeeView.subtitleLabel.text = "An entry fee is a fee charged to investors upon their investment to a GV Fund. The maximum entry fee is 0 %"
        exitFeeView.titleLabel.text = "Exit fee"
        exitFeeView.textField.text = ""
        exitFeeView.subtitleLabel.text = "An exit fee is a fee charged to investors when they redeem shares from a GV Fund. The maximum exit fee is 0 %"
        
        depositTitle.text = "Deposit details"
        fromView.titleLabel.text = "From"
        fromView.textLabel.text = "Bitcoin | BTC"
        fromView.selectButton.isEnabled = true
    }
    
    func updateProgressView(_ assets: [AssetModel]?) {
        guard let assets = assets else { return }
        
        for (index, asset) in assets.enumerated() {
            if let value = asset.value, asset.symbol != nil {
                DispatchQueue.main.async {
                    self.progressView.setProgress(section: index, to: Float(Double(value) / 100))
                }
            }
        }
    }
}
extension CreateFundStackView: MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 100
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        
        switch section {
        case 0:
            sectionView.backgroundColor = UIColor.Common.primary
        case 1:
            sectionView.backgroundColor = UIColor.Common.yellow
        case 2:
            sectionView.backgroundColor = UIColor.Common.purple
        default:
            sectionView.backgroundColor = UIColor.Common.red
        }
        
        return sectionView
    }
}
class MakeProgramStackView: UIStackView {
    @IBOutlet weak var mainSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var nameView: TextFieldStackView!
    @IBOutlet weak var descriptionView: TextViewStackView!
    @IBOutlet weak var uploadLogoView: ImageViewStackView!
    
    @IBOutlet weak var periodView: SelectStackView!
    @IBOutlet weak var stopOutView: TextFieldStackView!
    @IBOutlet weak var tradesDelayView: SelectStackView!
    
    @IBOutlet weak var feesSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var entryFeeView: TextFieldStackView!
    @IBOutlet weak var successFeeView: TextFieldStackView!
    
    @IBOutlet weak var limitTitle: LargeTitleLabel!
    @IBOutlet weak var limitView: LimitStackView!
    
    @IBOutlet weak var actionButton: ActionButton!
    
    func configure() {
        mainSettingsTitle.text = "Main settings"
        nameView.titleLabel.text = "Name"
        nameView.textField.text = ""
        nameView.subtitleLabel.text = "Requirement from 4 to 20 symbols"
        
        descriptionView.titleLabel.text = "Description"
        descriptionView.textView.text = ""
        descriptionView.subtitleLabel.text = "Requirement from 20 to 500 symbols"
        
        uploadLogoView.logoStackView.isHidden = true
        
        feesSettingsTitle.text = "Fees settings"
        entryFeeView.titleLabel.text = "Entry fee"
        entryFeeView.textField.text = ""
        entryFeeView.subtitleLabel.text = "A fee charged upon each investment in the program"
        successFeeView.titleLabel.text = "Success fee"
        successFeeView.textField.text = ""
        successFeeView.subtitleLabel.text = "A fee charged upon the total profit made within the reporting period"
        
        limitTitle.text = "Investment limit"
        limitView.titleLabel.text = "Investment limit"
        limitView.textField.text = ""
        limitView.limitSwitch.isOn = false
    }
}
class MakeSignalStackView: UIStackView {
    @IBOutlet weak var mainSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var nameView: TextFieldStackView!
    @IBOutlet weak var descriptionView: TextViewStackView!
    @IBOutlet weak var uploadLogoView: ImageViewStackView!
    
    @IBOutlet weak var feesSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var volumeFeeView: TextFieldStackView!
    @IBOutlet weak var signalSuccessFeeView: TextFieldStackView!
    
    @IBOutlet weak var actionButton: ActionButton!
    
    func configure() {
        mainSettingsTitle.text = "Main settings"
        nameView.titleLabel.text = "Name"
        nameView.textField.text = ""
        nameView.subtitleLabel.text = "Requirement from 4 to 20 symbols"
        
        descriptionView.titleLabel.text = "Description"
        descriptionView.textView.text = ""
        descriptionView.subtitleLabel.text = "Requirement from 20 to 500 symbols"
        
        uploadLogoView.logoStackView.isHidden = true
        
        feesSettingsTitle.text = "Signal provider fees"
        volumeFeeView.titleLabel.text = "Entry fee"
        volumeFeeView.textField.text = ""
        volumeFeeView.subtitleLabel.text = "A fee charged for the copied volume"
        signalSuccessFeeView.titleLabel.text = "Success fee"
        signalSuccessFeeView.textField.text = ""
        signalSuccessFeeView.subtitleLabel.text = "A fee charged for the profit made from copied successful trades"
    }
}
class LimitStackView: BaseStackView {
    @IBOutlet weak var limitSwitch: UISwitch! {
        didSet {
            limitSwitch.onTintColor = UIColor.primary
            limitSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            limitSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var textField: DesignableUITextField! {
        didSet {
            textField.setClearButtonWhileEditing()
        }
    }
}
class BaseStackView: UIStackView {
    @IBOutlet weak var titleLabel: SubtitleLabel!
    @IBOutlet weak var bottomLineView: UIView! {
        didSet {
            bottomLineView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        }
    }
    @IBOutlet weak var subtitleLabel: SubtitleLabel!
    @IBOutlet weak var subtitleValueLabel: TitleLabel!
}
class TextFieldStackView: BaseStackView {
    @IBOutlet weak var textField: DesignableUITextField! {
        didSet {
            textField.setClearButtonWhileEditing()
            textField.isSecureTextEntry = false
        }
    }
    @IBOutlet weak var maxButton: UIButton!
}
class TextViewStackView: BaseStackView {
    @IBOutlet weak var textView: UITextView!
}
class ImageViewStackView: BaseStackView {
    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.roundCorners(with: 6.0)
            imageView.backgroundColor = .primary
        }
    }
    @IBOutlet weak var deleteLogoButton: UIButton! {
        didSet {
            deleteLogoButton.setImage(#imageLiteral(resourceName: "img_trade_close"), for: .normal)
        }
    }
    @IBOutlet weak var uploadLogoButton: UIButton! {
       didSet {
           uploadLogoButton.setImage(#imageLiteral(resourceName: "img_add_photo_icon"), for: .normal)
       }
   }
    
    // MARK: - IBAction
    @IBAction func deleteLogoButtonAction(_ sender: UIButton) {
        uploadLogoButton.isHidden = false
        logoStackView.isHidden = true
        imageView.image = UIImage.fundPlaceholder
    }
}
class SelectStackView: BaseStackView {
    @IBOutlet weak var textLabel: TitleLabel!
    @IBOutlet weak var selectButton: UIButton!
}
class MainSettingsView: UIStackView {
    @IBOutlet weak var titleTextLabel: LargeTitleLabel!
    @IBOutlet weak var logoView: ImageViewStackView!
    @IBOutlet weak var nameView: TextFieldStackView!
    @IBOutlet weak var descView: TextViewStackView!
}
class LabelWithTitle: UIStackView {
    @IBOutlet weak var titleLabel: SubtitleLabel!
    @IBOutlet weak var valueLabel: TitleLabel! {
        didSet {
            valueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var percentValueLabel: TitleLabel! {
        didSet {
            percentValueLabel.font = UIFont.getFont(.bold, size: 14.0)
        }
    }
}
class LabelWithChart: UIStackView {
    @IBOutlet weak var circleView: UIView! {
        didSet {
            circleView.roundCorners()
        }
    }
    @IBOutlet weak var labelsView: LabelWithTitle!
}
class ChangeLabelsView: UIStackView {
    @IBOutlet weak var dayLabel: LabelWithTitle!
    @IBOutlet weak var weekLabel: LabelWithTitle!
    @IBOutlet weak var monthLabel: LabelWithTitle!
}

// MARK: - Overview Cell
class DashboardOverviewLabelsView: UIStackView {
    @IBOutlet weak var totalView: LabelWithTitle!
    @IBOutlet weak var progressView: MultiProgressView! {
        didSet {
            progressView.trackBackgroundColor = UIColor.BaseView.bg
            progressView.lineCap = .round
            progressView.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var investedView: LabelWithChart!
    @IBOutlet weak var tradingView: LabelWithChart!
    @IBOutlet weak var walletsView: LabelWithChart!
    
    @IBOutlet weak var changeLabelsView: ChangeLabelsView!
    
    func configure(_ data: DashboardOverviewData) {
        let currency = data.currency
        
        totalView.valueLabel.font = UIFont.getFont(.semibold, size: 27.0)
        totalView.titleLabel.text = "total"
        totalView.valueLabel.text = data.total.getString(with: currency)
        
        investedView.circleView.backgroundColor = UIColor.Common.primary
        investedView.labelsView.titleLabel.text = "invested"
        investedView.labelsView.valueLabel.text = data.invested.getString(with: currency)
        
        tradingView.circleView.backgroundColor = UIColor.Common.yellow
        tradingView.labelsView.titleLabel.text = "trading"
        tradingView.labelsView.valueLabel.text = data.trading.getString(with: currency)
        
        walletsView.circleView.backgroundColor = UIColor.Common.purple
        walletsView.labelsView.titleLabel.text = "wallets"
        walletsView.labelsView.valueLabel.text = data.wallets.getString(with: currency)
        
        let day = data.profits.day
        changeLabelsView.dayLabel.titleLabel.text = "day"
        changeLabelsView.dayLabel.valueLabel.text = day.value.toString() + " " + currency.rawValue
        changeLabelsView.dayLabel.percentValueLabel.text = day.percent.toString() + "%"
        changeLabelsView.dayLabel.percentValueLabel.textColor = day.percent == 0 ? UIColor.Cell.title : day.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        
        let week = data.profits.week
        changeLabelsView.weekLabel.titleLabel.text = "week"
        changeLabelsView.weekLabel.valueLabel.text = week.value.toString() + " " + currency.rawValue
        changeLabelsView.weekLabel.percentValueLabel.text = week.percent.toString() + "%"
        changeLabelsView.weekLabel.percentValueLabel.textColor = week.percent == 0 ? UIColor.Cell.title : week.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        
        let month = data.profits.month
        changeLabelsView.monthLabel.titleLabel.text = "month"
        changeLabelsView.monthLabel.valueLabel.text = month.value.toString() + " " + currency.rawValue
        changeLabelsView.monthLabel.percentValueLabel.text = month.percent.toString() + "%"
        changeLabelsView.monthLabel.percentValueLabel.textColor = month.percent == 0 ? UIColor.Cell.title : month.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
    }
}

// MARK: - Chart asset Cell
class DashboardChartItemView: UIStackView {
    @IBOutlet weak var circleView: UIView! {
           didSet {
               circleView.roundCorners()
           }
       }
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var valueLabel: TitleLabel!
}

// MARK: - Trading Cell
class DashboardTradingLabelsView: UIStackView {
    @IBOutlet weak var yourEquityLabel: LabelWithTitle!
    @IBOutlet weak var aumLabel: LabelWithTitle!
    @IBOutlet weak var changeLabelsView: ChangeLabelsView!
    
    func configure(_ data: TradingHeaderData) {
        let currency = data.currency
        
        yourEquityLabel.titleLabel.text = "your equity"
        yourEquityLabel.valueLabel.text = data.yourEquity.toString() + " " + currency.rawValue
        yourEquityLabel.valueLabel.font = UIFont.getFont(.semibold, size: 27.0)
        
        aumLabel.titleLabel.text = "AUM"
        aumLabel.valueLabel.text = data.aum.toString() + " " + currency.rawValue
        aumLabel.valueLabel.font = UIFont.getFont(.semibold, size: 27.0)
        
        let day = data.profits.day
        changeLabelsView.dayLabel.titleLabel.text = "day"
        changeLabelsView.dayLabel.valueLabel.text = day.value.toString() + " " + currency.rawValue
        changeLabelsView.dayLabel.percentValueLabel.text = day.percent.toString() + "%"
        changeLabelsView.dayLabel.percentValueLabel.textColor = day.percent == 0 ? UIColor.Cell.title : day.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        
        let week = data.profits.week
        changeLabelsView.weekLabel.titleLabel.text = "week"
        changeLabelsView.weekLabel.valueLabel.text = week.value.toString() + " " + currency.rawValue
        changeLabelsView.weekLabel.percentValueLabel.text = week.percent.toString() + "%"
        changeLabelsView.weekLabel.percentValueLabel.textColor = week.percent == 0 ? UIColor.Cell.title : week.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        
        let month = data.profits.month
        changeLabelsView.monthLabel.titleLabel.text = "month"
        changeLabelsView.monthLabel.valueLabel.text = month.value.toString() + " " + currency.rawValue
        changeLabelsView.monthLabel.percentValueLabel.text = month.percent.toString() + "%"
        changeLabelsView.monthLabel.percentValueLabel.textColor = month.percent == 0 ? UIColor.Cell.title : month.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
    }
}

// MARK: - Investing Cell
class DashboardInvestingLabelsView: UIStackView {
    @IBOutlet weak var balanceLabel: LabelWithTitle!
    @IBOutlet weak var programsLabel: LabelWithTitle!
    @IBOutlet weak var fundsLabel: LabelWithTitle!
    @IBOutlet weak var changeLabelsView: ChangeLabelsView!
    
    func configure(_ data: InvestingHeaderData) {
        let currency = data.currency
        
        balanceLabel.titleLabel.text = "balance"
        balanceLabel.valueLabel.text = data.balance.toString() + " " + currency.rawValue
        balanceLabel.valueLabel.font = UIFont.getFont(.semibold, size: 27.0)
        
        programsLabel.titleLabel.text = "programs"
        programsLabel.valueLabel.text = data.programs.toString() + " " + currency.rawValue
        programsLabel.valueLabel.font = UIFont.getFont(.semibold, size: 21.0)
        
        fundsLabel.titleLabel.text = "funds"
        fundsLabel.valueLabel.text = data.funds.toString() + " " + currency.rawValue
        fundsLabel.valueLabel.font = UIFont.getFont(.semibold, size: 21.0)
        
        let day = data.profits.day
        changeLabelsView.dayLabel.titleLabel.text = "day"
        changeLabelsView.dayLabel.valueLabel.text = day.value.toString() + " " + currency.rawValue
        changeLabelsView.dayLabel.percentValueLabel.text = day.percent.toString() + "%"
        changeLabelsView.dayLabel.percentValueLabel.textColor = day.percent == 0 ? UIColor.Cell.title : day.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        
        let week = data.profits.week
        changeLabelsView.weekLabel.titleLabel.text = "week"
        changeLabelsView.weekLabel.valueLabel.text = week.value.toString() + " " + currency.rawValue
        changeLabelsView.weekLabel.percentValueLabel.text = week.percent.toString() + "%"
        changeLabelsView.weekLabel.percentValueLabel.textColor = week.percent == 0 ? UIColor.Cell.title : week.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        
        let month = data.profits.month
        changeLabelsView.monthLabel.titleLabel.text = "month"
        changeLabelsView.monthLabel.valueLabel.text = month.value.toString() + " " + currency.rawValue
        changeLabelsView.monthLabel.percentValueLabel.text = month.percent.toString() + "%"
        changeLabelsView.monthLabel.percentValueLabel.textColor = month.percent == 0 ? UIColor.Cell.title : month.percent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
    }
}

