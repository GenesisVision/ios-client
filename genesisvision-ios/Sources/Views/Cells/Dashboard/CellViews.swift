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
class TitleView: UIStackView {
    var titleLabel: TitleLabel = {
        let titleLabel = TitleLabel()
        titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        titleLabel.textAlignment = .center
        titleLabel.isHidden = false
        return titleLabel
    }()
    
    var balanceLabel: TitleLabel = {
        let balanceLabel = TitleLabel()
        balanceLabel.font = UIFont.getFont(.semibold, size: 18.0)
        balanceLabel.textAlignment = .center
        balanceLabel.isHidden = true
        return balanceLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(balanceLabel)
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func animate(_ yOffset: CGFloat, value: CGFloat = 30.0) {
        if yOffset <= value, balanceLabel.isHidden == false {
            hideBalance()
        } else if yOffset > value, titleLabel.isHidden == false {
            hideTitle()
        }
    }
    
    private func hideTitle() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10.0, options: UIView.AnimationOptions(), animations: {
            self.titleLabel.isHidden = true
            self.balanceLabel.isHidden = false
        })
    }
    
    private func hideBalance() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: {
            self.balanceLabel.isHidden = true
            self.titleLabel.isHidden = false
        })
    }
}

class ActionStackView: UIStackView {
    @IBOutlet weak var actionButton: ActionButton! {
        didSet {
            actionButton.setEnabled(false)
        }
    }
    
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
    
    func configure(_ viewModel: AttachAccountViewModel) {
        exchangeTitle.text = "Exchange"
        exchangeView.titleLabel.text = "Exhange"
        exchangeView.textLabel.text = viewModel.getExchange()
        exchangeView.selectButton.isHidden = !viewModel.isEnableExchangeSelector()
        exchangeView.textLabel.textColor = viewModel.isEnableExchangeSelector() ? UIColor.Cell.title : UIColor.Cell.subtitle
        
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
                            cellModelsForRegistration: viewModel.brokerCollectionViewModel.cellModelsForRegistration)
        
        collectionHeightConstraint.constant = viewModel.brokerCollectionViewModel.getCollectionViewHeight()
        self.layoutIfNeeded()
    }
    
    func setupCollectionView(_ collectionDataSourceProtocol: CollectionDataSourceProtocol,
                   cellModelsForRegistration: [CellViewAnyModel.Type]) {
        
        collectionView.delegate = collectionDataSourceProtocol
        collectionView.dataSource = collectionDataSourceProtocol
        
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
                            cellModelsForRegistration: viewModel.assetCollectionViewModel.cellModelsForRegistration)
        
        collectionHeightConstraint.constant = viewModel.assetCollectionViewModel.getCollectionViewHeight()
        self.layoutIfNeeded()
    }
    
    func setupCollectionView(_ collectionDataSourceProtocol: CollectionDataSourceProtocol,
                   cellModelsForRegistration: [CellViewAnyModel.Type]) {
        
        collectionView.delegate = collectionDataSourceProtocol
        collectionView.dataSource = collectionDataSourceProtocol
        
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
class DepositStackView: UIStackView {
    @IBOutlet weak var depositTitle: LargeTitleLabel!
    @IBOutlet weak var fromView: SelectStackView!
    @IBOutlet weak var amountView: TextFieldStackView!
}
class CreateAccountStackView: ActionStackView {
    @IBOutlet weak var selectBrokerView: SelectBrokerStackView!
    @IBOutlet weak var mainSettingsTitle: LargeTitleLabel!
    
    @IBOutlet weak var accountTypeView: SelectStackView!
    @IBOutlet weak var currencyView: SelectStackView!
    @IBOutlet weak var leverageView: SelectStackView!
    
    @IBOutlet weak var depositView: DepositStackView!
    
    func configure(_ viewModel: CreateAccountViewModel) {
        selectBrokerView.configure(viewModel)
        
        mainSettingsTitle.text = "Main settings"
        
        accountTypeView.titleLabel.text = "Exhange"
        accountTypeView.textLabel.text = viewModel.getAccountType()
        accountTypeView.selectButton.isHidden = !viewModel.isEnableAccountTypeSelector()
        accountTypeView.textLabel.textColor = viewModel.isEnableAccountTypeSelector() ? UIColor.Cell.title : UIColor.Cell.subtitle
        
        currencyView.titleLabel.text = "Currency"
        currencyView.textLabel.text = viewModel.getCurrency()
        currencyView.selectButton.isHidden = !viewModel.isEnableCurrencySelector()
        currencyView.textLabel.textColor = viewModel.isEnableCurrencySelector() ? UIColor.Cell.title : UIColor.Cell.subtitle
        
        leverageView.titleLabel.text = "Broker's leverage"
        leverageView.textLabel.text = viewModel.getLeverage()
        leverageView.selectButton.isHidden = !viewModel.isEnableLeverageSelector()
        leverageView.textLabel.textColor = viewModel.isEnableLeverageSelector() ? UIColor.Cell.title : UIColor.Cell.subtitle
        
        depositView.isHidden = !viewModel.isDepositRequired()
        
        if viewModel.isDepositRequired() {
            depositView.depositTitle.text = "Deposit details"
            
            depositView.fromView.titleLabel.text = "From"
            depositView.fromView.textLabel.text = viewModel.getSelectedWallet()
            depositView.fromView.subtitleLabel.text = "Available in the wallet"
            depositView.fromView.subtitleValueLabel.text = viewModel.getAvailable()
            depositView.fromView.selectButton.isEnabled = true
            
            depositView.amountView.titleLabel.text = "Enter correct amount"
            depositView.amountView.textField.text = ""
            depositView.amountView.approxLabel.text = ""
            depositView.amountView.currencyLabel.text = viewModel.getSelectedWalletCurrency()
            depositView.amountView.subtitleLabel.text = "min. deposit"
            depositView.amountView.subtitleValueLabel.text = viewModel.getMinDeposit()
        }
    }
}
class CreateFundStackView: ActionStackView {
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
    
    @IBOutlet weak var depositView: DepositStackView!
    
    var viewModel: CreateFundViewModel?
    
    func configure(_ viewModel: CreateFundViewModel) {
        self.viewModel = viewModel
        
        mainSettingsTitle.text = "Main settings"
        nameView.titleLabel.text = "Name"
        nameView.textField.text = viewModel.request.title ?? ""
        nameView.subtitleLabel.text = "Minimum 4 symbols"
        nameView.subtitleValueLabel.text = "0/20"
        
        descriptionView.titleLabel.text = "Description"
        descriptionView.textView.text = viewModel.request._description ?? ""
        descriptionView.subtitleLabel.text = "Minimum 20 symbols"
        descriptionView.subtitleValueLabel.text = "0 / 500"
        
        uploadLogoView.logoStackView.isHidden = true
        
        progressView.dataSource = self
        updateProgressView(viewModel.assetCollectionViewModel.assets)
        
        assetSelectionTitle.text = viewModel.assetCollectionViewModel.title
        assetStackView.configure(viewModel)
        
        feesSettingsTitle.text = "Fees settings"
        entryFeeView.titleLabel.text = "Entry fee"
        entryFeeView.textField.text = viewModel.request.entryFee?.toString() ?? ""
        entryFeeView.subtitleLabel.text = "A entry fee is a fee charged to investors upon their investment to a GV Fund. The maximum entry fee is 10 %"
        exitFeeView.titleLabel.text = "Exit fee"
        exitFeeView.textField.text = viewModel.request.exitFee?.toString() ?? ""
        exitFeeView.subtitleLabel.text = "An exit fee is a fee charged to investors when they redeem shares from a GV Fund. The maximum exit fee is 10 %"
        
        depositView.depositTitle.text = "Deposit details"
        
        depositView.fromView.titleLabel.text = "From"
        depositView.fromView.textLabel.text = viewModel.getSelectedWallet()
        depositView.fromView.subtitleLabel.text = "Available in the wallet"
        depositView.fromView.subtitleValueLabel.text = viewModel.getAvailable()
        depositView.fromView.selectButton.isEnabled = true
        
        depositView.amountView.titleLabel.text = "Enter correct amount"
        depositView.amountView.textField.text = viewModel.request.depositAmount?.toString() ?? ""
        depositView.amountView.approxLabel.text = viewModel.getApproxString(viewModel.request.depositAmount ?? 0.0)
        depositView.amountView.currencyLabel.text = viewModel.getSelectedWalletCurrency()
        depositView.amountView.subtitleLabel.text = "min. deposit"
        depositView.amountView.subtitleValueLabel.text = viewModel.getMinDeposit()
    }
    
    func updateProgressView(_ assets: [PlatformAsset]?) {
        guard let assets = assets else { return }
        
        for (index, asset) in assets.enumerated() {
            if let value = asset.mandatoryFundPercent, asset.asset != nil {
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
class MakeProgramStackView: ActionStackView {
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

    func configure(_ viewModel: MakeProgramViewModel) {
        mainSettingsTitle.text = "Main settings"
        nameView.titleLabel.text = "Name"
        nameView.textField.text = ""
        nameView.subtitleLabel.text = "Minimum 4 symbols"
        nameView.subtitleValueLabel.text = "0/20"
        
        descriptionView.titleLabel.text = "Description"
        descriptionView.textView.text = ""
        descriptionView.subtitleLabel.text = "Minimum 20 symbols"
        descriptionView.subtitleValueLabel.text = "0 / 500"
        
        uploadLogoView.logoStackView.isHidden = true
        
        periodView.titleLabel.text = "Period"
        periodView.textLabel.text = viewModel.getPeriods()
        periodView.selectButton.isHidden = !viewModel.isEnablePeriodsSelector()
        periodView.textLabel.textColor = viewModel.isEnablePeriodsSelector() ? UIColor.Cell.title : UIColor.Cell.subtitle
        
        tradesDelayView.titleLabel.text = "Trades delay"
        tradesDelayView.textLabel.text = viewModel.getTrades()
        tradesDelayView.selectButton.isHidden = !viewModel.isEnableTradesSelector()
        tradesDelayView.textLabel.textColor = viewModel.isEnableTradesSelector() ? UIColor.Cell.title : UIColor.Cell.subtitle
        
        feesSettingsTitle.text = "Fees settings"
        entryFeeView.titleLabel.text = "Management fee"
        entryFeeView.textField.text = ""
        entryFeeView.subtitleLabel.text = "A fee charged upon each investment in the program"
        successFeeView.titleLabel.text = "Success fee"
        successFeeView.textField.text = ""
        successFeeView.subtitleLabel.text = "A fee charged upon the total profit made within the reporting period"
        
        limitTitle.text = "Investment limit"
        limitView.titleLabel.text = "Investment limit"
        limitView.textField.text = ""
        limitView.limitSwitch.isOn = false
        limitView.subtitleLabel.text = "At any time you can enter or cancel certain limitations on av. to invest, or even prohibit new investments if your Investment limit is 0. If the investment limit you've entered is larger than the av. to invest value calculated for your current level, then you will only be able to attract the av. to invest value."
    }
}
class MakeSignalStackView: ActionStackView {
    @IBOutlet weak var mainSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var nameView: TextFieldStackView!
    @IBOutlet weak var descriptionView: TextViewStackView!
    @IBOutlet weak var uploadLogoView: ImageViewStackView!
    
    @IBOutlet weak var feesSettingsTitle: LargeTitleLabel!
    @IBOutlet weak var volumeFeeView: TextFieldStackView!
    @IBOutlet weak var signalSuccessFeeView: TextFieldStackView!
    
    func configure() {
        mainSettingsTitle.text = "Main settings"
        nameView.titleLabel.text = "Name"
        nameView.textField.text = ""
        nameView.subtitleLabel.text = "Minimum 4 symbols"
        nameView.subtitleValueLabel.text = "0/20"
        
        descriptionView.titleLabel.text = "Description"
        descriptionView.textView.text = ""
        descriptionView.subtitleLabel.text = "Minimum 20 symbols"
        descriptionView.subtitleValueLabel.text = "0 / 500"
        
        uploadLogoView.logoStackView.isHidden = true
        
        feesSettingsTitle.text = "Signal provider fees"
        volumeFeeView.titleLabel.text = "Management fee"
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
            limitSwitch.isOn = false
            limitSwitch.onTintColor = UIColor.primary
            limitSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            limitSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var currencyLabel: TitleLabel! {
        didSet {
            currencyLabel.textColor = UIColor.Cell.subtitle
            currencyLabel.font = UIFont.getFont(.semibold, size: 12)
            currencyLabel.text = ""
        }
    }
    @IBOutlet weak var amountView: UIStackView! {
        didSet {
            amountView.isHidden = true
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
    @IBOutlet weak var currencyLabel: TitleLabel! {
        didSet {
            currencyLabel.textColor = UIColor.Cell.subtitle
            currencyLabel.font = UIFont.getFont(.semibold, size: 12)
            currencyLabel.text = "%"
        }
    }
    @IBOutlet weak var approxLabel: TitleLabel! {
        didSet {
            approxLabel.textColor = UIColor.Cell.subtitle
            approxLabel.font = UIFont.getFont(.semibold, size: 12)
            approxLabel.textAlignment = .left
        }
    }
    @IBOutlet weak var maxButton: UIButton! {
        didSet {
            maxButton.setTitleColor(UIColor.Cell.title, for: .normal)
            maxButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
}
class TextViewStackView: BaseStackView {
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.font = UIFont.getFont(.regular, size: 16)
        }
    }
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
    @IBOutlet weak var valueLabel: TitleLabel!
    @IBOutlet weak var percentValueLabel: TitleLabel! {
        didSet {
            percentValueLabel.font = UIFont.getFont(.bold, size: 14.0)
        }
    }
}

class LabelWithCircle: UIStackView {
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
    @IBOutlet weak var investedView: LabelWithCircle!
    @IBOutlet weak var tradingView: LabelWithCircle!
    @IBOutlet weak var walletsView: LabelWithCircle!
    
    @IBOutlet weak var changeLabelsView: ChangeLabelsView!
    
    func configure(_ data: DashboardOverviewData) {
        let currency = data.currency
        
        totalView.valueLabel.font = UIFont.getFont(.semibold, size: 27.0)
        totalView.titleLabel.text = "total"
        totalView.valueLabel.text = data.total.getString(with: currency)
        
        investedView.circleView.backgroundColor = UIColor.Common.primary
        investedView.labelsView.titleLabel.text = "invested"
        investedView.labelsView.valueLabel.text = data.investedProgress.getPercentageString()
        
        tradingView.circleView.backgroundColor = UIColor.Common.yellow
        tradingView.labelsView.titleLabel.text = "trading"
        tradingView.labelsView.valueLabel.text = data.tradingProgress.getPercentageString()
        
        walletsView.circleView.backgroundColor = UIColor.Common.purple
        walletsView.labelsView.titleLabel.text = "wallets"
        walletsView.labelsView.valueLabel.text = data.walletsProgress.getPercentageString()
        
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
class DashboardTradingEmptyView: UIStackView {
    @IBOutlet weak var titleLabel: LargeTitleLabel!
    
    @IBOutlet weak var createAccountLabel: SubtitleLabel!
    @IBOutlet weak var createFundLabel: SubtitleLabel!
    
    @IBOutlet weak var createAccountButton: ActionButton!
    @IBOutlet weak var createFundButton: ActionButton!
}

class DashboardTradingLabelsView: UIStackView {
    @IBOutlet weak var yourEquityLabel: LabelWithTitle!
    @IBOutlet weak var aumLabel: LabelWithTitle!
    @IBOutlet weak var changeLabelsView: ChangeLabelsView!
    
    func configure(_ data: TradingHeaderData?) {
        guard let data = data else { return }
        
        let currency = data.currency
        
        yourEquityLabel.titleLabel.text = "your equity"
        yourEquityLabel.valueLabel.text = data.yourEquity.toString() + " " + currency.rawValue
        yourEquityLabel.valueLabel.font = UIFont.getFont(.semibold, size: 18.0)
        
        aumLabel.titleLabel.text = "AUM"
        aumLabel.valueLabel.text = data.aum.toString() + " " + currency.rawValue
        aumLabel.valueLabel.font = UIFont.getFont(.semibold, size: 18.0)
        
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
class DashboardInvestingEmptyView: UIStackView {
    @IBOutlet weak var titleLabel: LargeTitleLabel!
    
    @IBOutlet weak var subtitleLabel: SubtitleLabel!
    
    @IBOutlet weak var programsButton: ActionButton!
    @IBOutlet weak var fundsButton: ActionButton!
    @IBOutlet weak var assetsButton: ActionButton!
    
}

class DashboardInvestingLabelsView: UIStackView {
    @IBOutlet weak var balanceLabel: LabelWithTitle!
    @IBOutlet weak var changeLabelsView: ChangeLabelsView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var programsLabel: LabelWithTitle!
    @IBOutlet weak var fundsLabel: LabelWithTitle!
    @IBOutlet weak var assetsLabel: LabelWithTitle!
    
    func configure(_ data: InvestingHeaderData?) {
        guard let data = data else { return }
        let currency = "$"
        
        balanceLabel.titleLabel.text = "balance"
        balanceLabel.valueLabel.text = currency + " " + data.balance.rounded(toPlaces: 2).toString()
        balanceLabel.valueLabel.font = UIFont.getFont(.semibold, size: 18.0)
        
        programsLabel.titleLabel.text = "programs"
        programsLabel.valueLabel.text = data.programs.toString()
        programsLabel.valueLabel.font = UIFont.getFont(.semibold, size: 18.0)
        
        fundsLabel.titleLabel.text = "funds"
        fundsLabel.valueLabel.text = data.funds.toString()
        fundsLabel.valueLabel.font = UIFont.getFont(.semibold, size: 18.0)
        
        assetsLabel.titleLabel.text = "assets"
        assetsLabel.valueLabel.text = data.coins.toString()
        assetsLabel.valueLabel.font = UIFont.getFont(.semibold, size: 18.0)
        
        let day = data.profits.day
        changeLabelsView.dayLabel.titleLabel.text = "day"
        var dayValue = day.value.rounded(toPlaces: 2).toString()
        if dayValue.first == "-" {
            let i = dayValue.index(dayValue.startIndex, offsetBy: 1)
            dayValue.insert(contentsOf: currency, at: i)
            changeLabelsView.dayLabel.valueLabel.textColor = UIColor.Cell.redTitle
        } else {
            dayValue.insert(contentsOf: currency, at: dayValue.startIndex)
            changeLabelsView.dayLabel.valueLabel.textColor = UIColor.Cell.greenTitle
        }
        changeLabelsView.dayLabel.valueLabel.text = dayValue
        
        let week = data.profits.week
        var weekValue = week.value.rounded(toPlaces: 2).toString()
        if weekValue.first == "-" {
            let i = weekValue.index(weekValue.startIndex, offsetBy: 1)
            weekValue.insert(contentsOf: " " + currency, at: i)
            changeLabelsView.weekLabel.valueLabel.textColor = UIColor.Cell.redTitle
        } else {
            weekValue.insert(contentsOf: currency, at: weekValue.startIndex)
            changeLabelsView.weekLabel.valueLabel.textColor = UIColor.Cell.greenTitle
        }
        changeLabelsView.weekLabel.titleLabel.text = "week"
        changeLabelsView.weekLabel.valueLabel.text = weekValue
        
        let month = data.profits.month
        changeLabelsView.monthLabel.titleLabel.text = "month"
        var monthValue = month.value.rounded(toPlaces: 2).toString()
        if monthValue.first == "-" {
            let i = monthValue.index(monthValue.startIndex, offsetBy: 1)
            monthValue.insert(contentsOf: " " + currency, at: i)
            changeLabelsView.monthLabel.valueLabel.textColor = UIColor.Cell.redTitle
        } else {
            monthValue.insert(contentsOf: currency, at: monthValue.startIndex)
            changeLabelsView.monthLabel.valueLabel.textColor = UIColor.Cell.greenTitle
        }
        changeLabelsView.monthLabel.valueLabel.text = monthValue
    }
}

