//
//  FundInvestViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundInvestViewController: BaseViewController {
    
    var viewModel: FundInvestViewModel!
    
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
    
    @IBOutlet weak var amountToInvestTitleLabel: SubtitleLabel! {
        didSet {
            amountToInvestTitleLabel.isHidden = true
        }
    }
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
            managementFeeTitleLabel.text = "Entry fee"
            managementFeeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var commissionsStackView: UIStackView! {
        didSet {
            commissionsStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var entryFeeValueLabel: TitleLabel!
    
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

    // MARK: - Buttons
    @IBOutlet weak var investButton: ActionButton!
    
    // MARK: - Variables
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
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private methods
    private func setup() {
        investButton.setEnabled(false)
        title = ""
        
        showProgressHUD()
        viewModel.getInfo(completion: { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let errorType):
                DispatchQueue.main.async {
                    self?.updateUI()
                }
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        })
    }
    
    private func updateUI() {
        guard let fundCurrency = viewModel.fundCurrency, let walletCurrency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let walletCurrencyType = CurrencyType(rawValue: walletCurrency) else { return }
        
        amountToInvestTitleLabel.isHidden = false
        
        if let isOwner = viewModel.fundDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            title = "Deposit"
            commissionsStackView.isHidden = true
            amountToInvestTitleLabel.text = "Amount to deposit"
        } else {
            title = "Investment"
            commissionsStackView.isHidden = false
            amountToInvestTitleLabel.text = "Amount to invest"
        }
        
        //wallet
        self.selectedWalletFromValueLabel.text = viewModel.getSelectedWalletTitle()
        self.availableInWalletFromValue = viewModel.getAvailableInWallet()
        
        //investment
        if let walletCurrency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue {
            self.amountToInvestCurrencyLabel.text = walletCurrency
        }
        
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, fundCurrency.rawValue != currency {
            self.investmentAmountCurrencyLabel.text = viewModel.getInvestmentAmountCurrencyValue(amountToInvestValue)
        } else {
            self.investmentAmountCurrencyLabel.text = ""
        }
        
        if let selectedWalletFromDelegateManager = viewModel?.selectedWalletFromDelegateManager {
            selectedWalletFromDelegateManager.currencyDelegate = self
        }
        
        self.investmentAmountCurrencyLabel.text?.append(viewModel.getMinInvestmentAmountText())
        
        //let rate = viewModel.rate
        let entryFee = viewModel.getEntryFee()
        let gvCommission = viewModel.getGVCommision()
        
        let gvCommissionCurrency = gvCommission * amountToInvestValue / 100
        let gvCommissionCurrencyString = gvCommissionCurrency.rounded(with: walletCurrencyType).toString()
        let gvCommissionString = gvCommission.rounded(toPlaces: 3).toString()
        let gvCommissionValueLabelString = gvCommissionString + "% (≈\(gvCommissionCurrencyString) \(walletCurrencyType.rawValue))"
        self.gvCommissionValueLabel.text = gvCommissionValueLabelString
        
        let amounToInvestAfterGVCommision = amountToInvestValue - gvCommissionCurrency
        

        
        let entryFeeCurrency = entryFee * amounToInvestAfterGVCommision / 100
        let entryFeeCurrencyString = entryFeeCurrency.rounded(with: walletCurrencyType).toString()
        let entryFeeString = entryFee.rounded(toPlaces: 3).toString()
        
        let entryFeeValueLabelString = entryFeeString + "% (≈\(entryFeeCurrencyString) \(walletCurrencyType.rawValue))"
        self.entryFeeValueLabel.text = entryFeeValueLabelString
        
        let amountToInvestAfterAllCommission = (amounToInvestAfterGVCommision - entryFeeCurrency)
        

//        let investmentAmountValue = (amountToInvestValue * rate - entryFeeCurrency - gvCommissionCurrency * rate).rounded(with: fundCurrency).toString()
        self.investmentAmountValueLabel.text = "≈" + amountToInvestAfterAllCommission.toString() + " " + walletCurrencyType.rawValue
        
        let investButtonEnabled = amountToInvestValue >= viewModel.getMinInvestmentAmount()
        
        investButton.setEnabled(investButtonEnabled)
    }
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func investMethod() {
        let minInvestmentAmount = viewModel.getMinInvestmentAmount()
        guard amountToInvestValue >= minInvestmentAmount else { return showErrorHUD(subtitle: "Enter investment value, please") }
        
        showProgressHUD()
        viewModel.invest(with: amountToInvestValue) { [weak self] (result) in
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
        bottomSheetController.initializeHeight = 480.0
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
        
        guard let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency else { return }
        
        var firstValue: String?
        if let amount = amountToInvestValueLabel.text {
            firstValue = amount + " " + currency.rawValue
        }
        
        var confirmVCTitle = "Confirm Invest"
        let confirmVCSubtitle = "Your request will be processed within a few minutes."
        
        
        let firstTitle = amountToInvestTitleLabel.text
        var secondTitle: String?
        var secondValue: String?
        var thirdTitle: String?
        var thirdValue: String?
        var fourthTitle: String?
        var fourthValue: String?
        
        if let isOwner = viewModel.fundDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            confirmVCTitle = "Confirm Deposit"
        } else {
            secondTitle = managementFeeTitleLabel.text
            secondValue = entryFeeValueLabel.text
            thirdTitle = gvCommissionTitleLabel.text
            thirdValue = gvCommissionValueLabel.text
            fourthTitle = investmentAmountTitleLabel.text
            fourthValue = investmentAmountValueLabel.text
        }
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: confirmVCTitle,
                                                          subtitle: confirmVCSubtitle,
                                                          programLogo: nil,
                                                          programTitle: viewModel.fundDetailsFull?.publicInfo?.title,
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
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            
            amountToInvestValueLabel.text = availableInWalletFromValue.rounded(with: currencyType).toString(withoutFormatter: true)
            amountToInvestValue = availableInWalletFromValue
        }
    }
}

extension FundInvestViewController: WalletDelegateManagerProtocol {
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

extension FundInvestViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return viewModel.getMaxAmount()
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

extension FundInvestViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        investMethod()
    }
}
