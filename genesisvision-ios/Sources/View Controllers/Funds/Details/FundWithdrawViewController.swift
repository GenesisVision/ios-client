//
//  FundWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundWithdrawViewController: BaseViewController {

    var viewModel: FundWithdrawViewModel!
    
    @IBOutlet weak var mainStackView: UIStackView! {
        didSet {
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE:
                mainStackView.spacing = 8.0
            default:
                mainStackView.spacing = 32.0
            }
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var availableToWithdrawValueTitleLabel: SubtitleLabel! {
        didSet {
            availableToWithdrawValueTitleLabel.text = "Current invested value"
        }
    }
    @IBOutlet weak var availableToWithdrawValueLabel: TitleLabel!
    
    @IBOutlet weak var selectedWalletFromTitleLabel: SubtitleLabel! {
        didSet {
            selectedWalletFromTitleLabel.text = "To"
        }
    }
    @IBOutlet weak var selectedWalletFromButton: UIButton!
    @IBOutlet weak var selectedWalletFromValueLabel: TitleLabel! {
        didSet {
            selectedWalletFromValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var amountToWithdrawTitleLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawTitleLabel.text = "Amount to withdraw"
        }
    }
    @IBOutlet weak var amountToWithdrawValueLabel: TitleLabel! {
        didSet {
            amountToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var amountToWithdrawGVTLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawGVTLabel.text = "%"
            amountToWithdrawGVTLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var amountToWithdrawCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawCurrencyLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.isHidden = false
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet weak var exitFeeTitleLabel: SubtitleLabel! {
        didSet {
            exitFeeTitleLabel.text = "Exit fee"
            exitFeeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var exitFeeValueLabel: TitleLabel!
    
    @IBOutlet weak var withdrawingAmountTitleLabel: SubtitleLabel! {
        didSet {
            withdrawingAmountTitleLabel.text = "You will get approx."
            withdrawingAmountTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var withdrawingAmountValueLabel: TitleLabel! {
        didSet {
            withdrawingAmountValueLabel.text = "0 GVT"
        }
    }
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.text = "The withdrawal amount can be changed depending on the exchange rate or the success of the Manager."
            disclaimerLabel.isHidden = true
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
            disclaimerLabel.textAlignment = .justified
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var withdrawButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    // MARK: - Variables
    var amountToWithdrawValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var availableToWithdrawValue: Double = 0.0
    
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
        withdrawButton.setEnabled(false)

        showProgressHUD()
        viewModel.getInfo(completion: { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        })
    }
    
    private func updateUI() {
        guard let selectedWalletCurrency = viewModel.selectedWalletFromDelegateManager?.selected?.currency, let currencyType = CurrencyType(rawValue: selectedWalletCurrency.rawValue) else { return }
        
        if let selectedWalletFromDelegateManager = viewModel?.selectedWalletFromDelegateManager {
            selectedWalletFromDelegateManager.currencyDelegate = self
        }
        
        //wallet
        self.selectedWalletFromValueLabel.text = viewModel.getSelectedWalletTitle()
 
        let exitFee = viewModel.getExitFee()
        
        availableToWithdrawValue = viewModel.getAvailableToWithdraw()
        availableToWithdrawValueLabel.text = availableToWithdrawValue.toString() + " " + currencyType.rawValue
        
        let withdrawingValue = availableToWithdrawValue / 100 * amountToWithdrawValue
        
        self.amountToWithdrawCurrencyLabel.text = "≈" + withdrawingValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        
        let exitFeeString = exitFee.rounded(with: .undefined).toString()
        
        let exitFeeCurrency = withdrawingValue / 100 * exitFee
        let exitFeeCurrencyString = exitFeeCurrency.rounded(with: currencyType).toString()
        
        let exitFeeValueLabelString = exitFeeString + "% (≈" + exitFeeCurrencyString + " " + currencyType.rawValue + ")"
        self.exitFeeValueLabel.text = exitFeeValueLabelString
        
        let withdrawingAmountValue = (withdrawingValue - exitFeeCurrency).rounded(with: currencyType).toString()
        self.withdrawingAmountValueLabel.text = "≈" + withdrawingAmountValue + " " + currencyType.rawValue
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0 && amountToWithdrawValue <= 100
        
        withdrawButton.setEnabled(withdrawButtonEnabled)
    }
    
    private func withdrawMethod() {
        guard let text = amountToWithdrawValueLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter withdraw value, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amount) { [weak self] (result) in
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
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 430.0
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
        var amountText = ""
        if let amountToWithdrawValue = amountToWithdrawValueLabel.text, let amountToWithdrawCurrency = amountToWithdrawCurrencyLabel.text {
            amountText = amountToWithdrawValue + "% (" + amountToWithdrawCurrency + ")"
        }
        
        let subtitle = "Your request will be processed within a few minutes."
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Withdraw",
                                                          subtitle: subtitle,
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: "Amount to withdraw",
                                                          firstValue: amountText,
                                                          secondTitle: exitFeeTitleLabel.text,
                                                          secondValue: exitFeeValueLabel.text,
                                                          thirdTitle: "You will get approximately",
                                                          thirdValue: withdrawingAmountValueLabel.text,
                                                          fourthTitle: nil,
                                                          fourthValue: nil)
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
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        showConfirmVC()
    }
    
    @IBAction func copyAllButtonAction(_ sender: UIButton) {
        amountToWithdrawValueLabel.text = maxAmount?.toString()
        amountToWithdrawValue = maxAmount ?? 0.0
    }
}

extension FundWithdrawViewController: WalletDelegateManagerProtocol {
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

extension FundWithdrawViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return 100
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return nil
    }
    
    var currency: CurrencyType? {
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToWithdrawValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value else { return }
        
        numpadView.isEnable = true
        amountToWithdrawValue = value
    }
}


extension FundWithdrawViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        withdrawMethod()
    }
}
