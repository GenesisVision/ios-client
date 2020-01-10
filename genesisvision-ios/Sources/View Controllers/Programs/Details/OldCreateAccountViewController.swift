//
//  OldCreateAccountViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class OldCreateAccountViewController: BaseViewController {
    
    var viewModel: OldCreateAccountViewModel!
    
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
    
    @IBOutlet weak var amountToDepositTitleLabel: SubtitleLabel! {
        didSet {
            amountToDepositTitleLabel.text = "Deposit amount"
        }
    }
    @IBOutlet weak var amountToDepositTextField: InputTextField! {
        didSet {
            amountToDepositTextField.addTarget(self, action: #selector(amountToDepositTextFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var amountToDepositCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToDepositCurrencyLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    @IBOutlet weak var investmentAmountCurrencyLabel: SubtitleLabel!
    
    // MARK: - Buttons
    @IBOutlet weak var nextButton: ActionButton!
    
    // MARK: - Variables
    var amountToDepositValue: Double = 0.0 {
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
        nextButton.setEnabled(false)
        
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
        guard let programCurrency = viewModel.programCurrency else { return }
        
        //wallet
        self.selectedWalletFromValueLabel.text = viewModel.getSelectedWalletTitle()
        self.availableInWalletFromValue = viewModel.getAvailableInWallet()
        
        //investment
//        if let walletCurrency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue {
//            self.amountToDepositCurrencyLabel.text = walletCurrency
//        }
        
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, programCurrency.rawValue != currency {
            self.investmentAmountCurrencyLabel.text = viewModel.getInvestmentAmountCurrencyValue(amountToDepositValue)
        } else {
            self.investmentAmountCurrencyLabel.text = ""
        }
        
        if let selectedWalletFromDelegateManager = viewModel?.selectedWalletFromDelegateManager {
            selectedWalletFromDelegateManager.currencyDelegate = self
        }
        
//        self.investmentAmountCurrencyLabel.text?.append(viewModel.getMinInvestmentAmountText())
        
        let rate = viewModel.rate

        let investmentAmountValue = (amountToDepositValue * rate).rounded(with: programCurrency).toString()
        self.investmentAmountCurrencyLabel.text = "≈" + investmentAmountValue + " " + programCurrency.rawValue
        
        let nextButtonEnabled = amountToDepositValue > 0.0
        
        nextButton.setEnabled(nextButtonEnabled)
    }
    
    @objc private func amountToDepositTextFieldDidChange(_ textField: UITextField) {
        amountToDepositValue = textField.text?.doubleValue ?? 0.0
    }
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func createAccountMethod() {
        viewModel.create(amountToDepositValue)
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
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        createAccountMethod()
    }
    
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            
            amountToDepositValue = availableInWalletFromValue.rounded(with: currencyType)
            
            amountToDepositTextField.text = amountToDepositValue.toString(withoutFormatter: true)
        }
    }
}

extension OldCreateAccountViewController: WalletDelegateManagerProtocol {
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
