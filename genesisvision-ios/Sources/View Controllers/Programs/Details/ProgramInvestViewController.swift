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
    
    @IBOutlet weak var amountToInvestTitleLabel: SubtitleLabel! {
        didSet {
            amountToInvestTitleLabel.text = "Amount to invest"
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
        
        //wallet
        self.selectedWalletFromValueLabel.text = viewModel.getSelectedWalletTitle()
        self.availableInWalletFromValue = viewModel.getAvailableInWallet()
    
        //investment
        self.amountToInvestCurrencyLabel.text = walletCurrency
        
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, programCurrency.rawValue != currency {
            self.investmentAmountCurrencyLabel.text = viewModel.getInvestmentAmountCurrencyValue(amountToInvestValue)
        } else {
            self.investmentAmountCurrencyLabel.text = ""
        }
        
        if let selectedWalletFromDelegateManager = viewModel?.selectedWalletFromDelegateManager {
            selectedWalletFromDelegateManager.currencyDelegate = self
        }
        
        self.investmentAmountCurrencyLabel.text?.append(viewModel.getMinInvestmentAmountText())
        
        let rate = viewModel.rate
        let managementFee = viewModel.getManagementFee()
        let gvCommission = viewModel.getGVCommision()
        
        self.managementFeeValueLabel.text = managementFee.rounded(with: programCurrency).toString() + "% (annual)"

        let gvCommissionCurrency = gvCommission * amountToInvestValue / 100
        let gvCommissionCurrencyString = gvCommissionCurrency.rounded(toPlaces: 8).toString()
        let gvCommissionString = gvCommission.rounded(toPlaces: 8).toString()

        let gvCommissionValueLabelString = gvCommissionString + "% (≈\(gvCommissionCurrencyString) \(walletCurrencyType.rawValue))"
        self.gvCommissionValueLabel.text = gvCommissionValueLabelString
        let investmentAmountValue = (amountToInvestValue * rate - gvCommissionCurrency * rate).rounded(with: programCurrency).toString()
        self.investmentAmountValueLabel.text = "≈" + investmentAmountValue + " " + programCurrency.rawValue
    
        self.availableToInvestValue = viewModel.getAvailableToInvest()
        
        let investButtonEnabled = amountToInvestValue * rate >= viewModel.getMinInvestmentAmount() && amountToInvestValue * rate <= availableToInvestValue
        
        investButton.setEnabled(investButtonEnabled)
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
        
        let subtitle = "Your request will be processed at the end of the reporting period."
        guard let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency else { return }
        
        var firstValue: String?
        if let amount = amountToInvestValueLabel.text {
             firstValue = amount + " " + currency.rawValue
        }
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Invest",
                                                          subtitle: subtitle,
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: amountToInvestTitleLabel.text,
                                                          firstValue: firstValue,
                                                          secondTitle: managementFeeTitleLabel.text,
                                                          secondValue: managementFeeValueLabel.text,
                                                          thirdTitle: gvCommissionTitleLabel.text,
                                                          thirdValue: gvCommissionValueLabel.text,
                                                          fourthTitle: investmentAmountTitleLabel.text,
                                                          fourthValue: investmentAmountValueLabel.text)
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
            
            let minValue = min(availableToInvestValue / rate, availableInWalletFromValue).rounded(with: currencyType)
            
            amountToInvestValueLabel.text = minValue.toString(withoutFormatter: true)
            amountToInvestValue = minValue
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

extension ProgramInvestViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        investMethod()
    }
}
