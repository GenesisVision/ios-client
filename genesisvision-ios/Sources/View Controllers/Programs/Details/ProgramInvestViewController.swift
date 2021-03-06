//
//  ProgramInvestViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramInvestViewController: BaseViewController {
    
    var viewModel: ProgramInvestViewModel!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var availableToInvestStackView: UIStackView! {
        didSet {
            availableToInvestStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var availableToInvestTitleLabel: SubtitleLabel! {
        didSet {
            availableToInvestTitleLabel.text = "Available to invest in program"
        }
    }
    
    @IBOutlet weak var availableToInvestValueLabel: TitleLabel!
    
    @IBOutlet weak var selectedWalletFromTitleLabel: SubtitleLabel! {
        didSet {
            selectedWalletFromTitleLabel.text = "From"
        }
    }
    
    @IBOutlet weak var selectedWalletFromButton: UIButton!
    
    @IBOutlet weak var selectedWalletFromValueLabel: TitleLabel! {
        didSet {
            selectedWalletFromValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var availableInWalletTitleLabel: SubtitleLabel! {
        didSet {
            availableInWalletTitleLabel.text = "Available in wallet"
        }
    }
    
    @IBOutlet weak var availableInWalletValueLabel: TitleLabel!
    
    @IBOutlet weak var amountToInvestTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var amountToInvestValueLabel: TitleLabel! {
        didSet {
            amountToInvestValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var amountToInvestCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToInvestCurrencyLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet weak var managementFeeTitleLabel: SubtitleLabel! {
        didSet {
            managementFeeTitleLabel.text = "Management fee"
            managementFeeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var managementFeeValueLabel: TitleLabel!
    
    @IBOutlet weak var gvCommissionTitleLabel: SubtitleLabel! {
        didSet {
            gvCommissionTitleLabel.text = "GV commission"
            gvCommissionTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var gvCommissionValueLabel: TitleLabel!
    
    @IBOutlet weak var investmentAmountTitleLabel: SubtitleLabel! {
        didSet {
            investmentAmountTitleLabel.text = "Investment amount"
            investmentAmountTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var investmentAmountValueLabel: TitleLabel! {
        didSet {
            if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency {
                investmentAmountValueLabel.text = "0 " + currency.rawValue
            }
        }
    }
    @IBOutlet weak var investmentAmountCurrencyLabel: SubtitleLabel!
    
    @IBOutlet weak var commissionView: UIView! {
        didSet {
            commissionView.isHidden = true
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var investButton: ActionButton!
    
    // MARK: - Variables
    var availableToInvestValue: Double = 0.0 {
        didSet {
            if let programCurrency = viewModel.programCurrency {
                self.availableToInvestValueLabel.text = availableToInvestValue.rounded(with: programCurrency).toString() + " " + programCurrency.rawValue
            }
        }
    }
    
    var amountToInvestValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var availableInWalletFromValue: Double = 0.0 {
        didSet {
            if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
                self.availableInWalletValueLabel.text = availableInWalletFromValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        investButton.setEnabled(false)
        
        title = ""
        
        showProgressHUD()
        viewModel.getInfo { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    
    private func updateUI() {
        guard let programCurrency = viewModel.programCurrency, let walletCurrency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let walletCurrencyType = CurrencyType(rawValue: walletCurrency) else { return }
        
        if let isOwner = viewModel.programFollowDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            title = "Deposit"
            amountToInvestTitleLabel.text = "Amount to deposit"
        } else {
            title = "Investment"
            amountToInvestTitleLabel.text = "Amount to invest"
            commissionView.isHidden = false
            availableToInvestStackView.isHidden = false
        }
        
        //wallet
        selectedWalletFromValueLabel.text = viewModel.getSelectedWalletTitle()
        availableInWalletFromValue = viewModel.getAvailableInWallet()
    
        //investment
        amountToInvestCurrencyLabel.text = walletCurrency
        
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, programCurrency.rawValue != currency {
            investmentAmountCurrencyLabel.text = viewModel.getInvestmentAmountCurrencyValue(amountToInvestValue)
        } else {
            investmentAmountCurrencyLabel.text = ""
        }
        
        if let selectedWalletFromDelegateManager = viewModel?.selectedWalletFromDelegateManager {
            selectedWalletFromDelegateManager.currencyDelegate = self
        }
        
        investmentAmountCurrencyLabel.text?.append(viewModel.getMinInvestmentAmountText())
        
        let rate = viewModel.rate
        let managementFee = viewModel.getManagementFee()
        let gvCommission = viewModel.getGVCommision()
        
        managementFeeValueLabel.text = managementFee.rounded(with: programCurrency).toString() + "% (annual)"

        let gvCommissionCurrency = gvCommission * amountToInvestValue / 100
        let gvCommissionCurrencyString = gvCommissionCurrency.rounded(toPlaces: 8).toString()
        let gvCommissionString = gvCommission.rounded(toPlaces: 8).toString()

        let gvCommissionValueLabelString = gvCommissionString + "% (≈\(gvCommissionCurrencyString) \(walletCurrencyType.rawValue))"
        gvCommissionValueLabel.text = gvCommissionValueLabelString
        let investmentAmountValue = (amountToInvestValue * rate - gvCommissionCurrency * rate).rounded(with: programCurrency).toString()
        investmentAmountValueLabel.text = "≈" + investmentAmountValue + " " + programCurrency.rawValue
        
        if viewModel.programDetailsFull == nil {
            let investButtonEnabled = amountToInvestValue >= viewModel.getMinInvestmentAmount()
            investButton.setEnabled(investButtonEnabled)
        } else if let isOwner = viewModel.programFollowDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            availableToInvestValue = viewModel.getAvailableToInvest()
            let investButtonEnabled = amountToInvestValue >= viewModel.getMinInvestmentAmount()
            investButton.setEnabled(investButtonEnabled)
        } else {
            availableToInvestValue = viewModel.getAvailableToInvest()
            let investButtonEnabled = amountToInvestValue >= viewModel.getMinInvestmentAmount() && amountToInvestValue * rate <= availableToInvestValue
            investButton.setEnabled(investButtonEnabled)
        }

    }
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func investMethod() {
        let rate = viewModel.rate
        let minInvestmentAmount = viewModel.getMinInvestmentAmount()
        guard amountToInvestValue * rate >= minInvestmentAmount, let walletId = viewModel.selectedWalletFromDelegateManager?.selected?._id else { return showErrorHUD(subtitle: "Enter investment value, please") }
        
        showProgressHUD()
        viewModel.invest(with: amountToInvestValue, walletId: walletId) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.viewModel.goToBack()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.tintColor = UIColor.Cell.bg
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 500.0
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
        
        var subtitle: String = "Your request will be processed at the end of the reporting period."
        
        if viewModel.programFollowDetailsFull?.brokerDetails?.type == .binance, let realTime = viewModel.programDetailsFull?.dailyPeriodDetails?.isProcessingRealTime, !realTime, let date = viewModel.programDetailsFull?.dailyPeriodDetails?.nextProcessingDate {
            subtitle = "Your request will be processed at \(date) GMT."
        }
        
        guard let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency else { return }
        
        var firstValue: String?
        if let amount = amountToInvestValueLabel.text {
             firstValue = amount + " " + currency.rawValue
        }
        
        var confirmVCTitle = "Confirm Invest"
        
        let firstTitle = amountToInvestTitleLabel.text
        var secondTitle: String?
        var secondValue: String?
        var thirdTitle: String?
        var thirdValue: String?
        var fourthTitle: String?
        var fourthValue: String?
        
        if let isOwner = viewModel.programFollowDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            confirmVCTitle = "Confirm Deposit"
        } else {
            secondTitle = managementFeeTitleLabel.text
            secondValue = managementFeeValueLabel.text
            thirdTitle = gvCommissionTitleLabel.text
            thirdValue = gvCommissionValueLabel.text
            fourthTitle = investmentAmountTitleLabel.text
            fourthValue = investmentAmountValueLabel.text
        }
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: confirmVCTitle,
                                                          subtitle: subtitle,
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: firstTitle,
                                                          firstValue: firstValue,
                                                          secondTitle: secondTitle,
                                                          secondValue: secondValue,
                                                          thirdTitle: thirdTitle,
                                                          thirdValue: thirdValue,
                                                          fourthTitle: fourthTitle,
                                                          fourthValue: fourthValue)
        confirmView.configure(model: confirmViewModel)
        bottomSheetController.addContentsView(confirmView)
        confirmView.delegate = self
        bottomSheetController.present()
    }
    
    @IBAction func selectedWalletCurrencyFromButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        viewModel?.selectedWalletFromDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0
        
        bottomSheetController.addNavigationBar(selectedWalletFromTitleLabel.text)
        
        bottomSheetController.addTableView { [weak self] tableView in
            self?.viewModel.selectedWalletFromDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let selectedWalletFromDelegateManager = self?.viewModel.selectedWalletFromDelegateManager else { return }
            tableView.registerNibs(for: selectedWalletFromDelegateManager.cellModelsForRegistration)
            tableView.delegate = selectedWalletFromDelegateManager
            tableView.dataSource = selectedWalletFromDelegateManager
        }
        
        bottomSheetController.present()
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: UIButton) {
        showConfirmVC()
    }
    
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        let rate = viewModel.rate
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            
            var minValue: Double?
            
            if let isOwner = viewModel.programFollowDetailsFull?.publicInfo?.isOwnAsset, isOwner {
                minValue = availableInWalletFromValue.rounded(with: currencyType)
            } else {
                minValue = min(availableToInvestValue / rate, availableInWalletFromValue).rounded(with: currencyType)
            }
            
            amountToInvestValueLabel.text = minValue?.toString(withoutFormatter: true)
            amountToInvestValue = minValue ?? 0.0
        }
    }
}

extension ProgramInvestViewController: WalletDelegateManagerProtocol {
    func didSelectWallet(at indexPath: IndexPath, walletId: Int) {
        self.showProgressHUD()
        self.viewModel.updateWalletCurrencyFromIndex(indexPath.row) { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
        
        bottomSheetController.dismiss()
    }
}

extension ProgramInvestViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        if let isOwner = viewModel.programFollowDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            return nil
        } else {
            return viewModel.getMaxAmount()
        }
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        return viewModel.walletCurrency
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToInvestValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value else { return }
        
        numpadView.isEnable = true
        amountToInvestValue = value
    }
}

extension ProgramInvestViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        investMethod()
    }
}
