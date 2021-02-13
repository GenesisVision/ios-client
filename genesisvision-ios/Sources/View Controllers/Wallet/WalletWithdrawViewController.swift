//
//  WalletWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import AVFoundation

class WalletWithdrawViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: WalletWithdrawViewModel!
    
    // MARK: - Variables
    private var readQRCodeButton: UIButton?
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    var amountToWithdrawValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var availableInWalletValue: Double = 0.0 {
        didSet {
            if let currency = viewModel.selectedWallet?.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                self.availableInWalletValueLabel.text = availableInWalletValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var numpadHeightConstraint: NSLayoutConstraint! {
        didSet {
            numpadHeightConstraint.constant = 0.0
        }
    }
    @IBOutlet weak var numpadBackView: UIView! {
        didSet {
            numpadBackView.isHidden = true
            numpadBackView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideNumpadView))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.delegate = self
            numpadBackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    @IBOutlet weak var availableInWalletValueTitleLabel: SubtitleLabel! {
        didSet {
            availableInWalletValueTitleLabel.text = "Available in wallet"
        }
    }
    @IBOutlet weak var availableInWalletValueLabel: TitleLabel! {
        didSet {
            availableInWalletValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var amountToWithdrawTitleLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawTitleLabel.text = "Enter correct amount"
        }
    }
    @IBOutlet weak var amountToWithdrawValueLabel: TitleLabel! {
        didSet {
            amountToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var amountToWithdrawCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawCurrencyLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var selectedWalletCurrencyButton: UIButton!
    @IBOutlet weak var selectedWalletCurrencyTitleLabel: SubtitleLabel! {
        didSet {
            selectedWalletCurrencyTitleLabel.text = "Select a wallet currency"
        }
    }
    @IBOutlet weak var selectedWalletCurrencyValueLabel: TitleLabel! {
        didSet {
            selectedWalletCurrencyValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet weak var scanQRButton: UIButton! {
        didSet {
            scanQRButton.setTitleColor(UIColor.Cell.title, for: .normal)
            scanQRButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet weak var feeTitleLabel: SubtitleLabel! {
        didSet {
            feeTitleLabel.text = "Fee"
            feeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var feeValueLabel: TitleLabel!
    @IBOutlet weak var withdrawingTitleLabel: SubtitleLabel! {
        didSet {
            withdrawingTitleLabel.text = "You will get"
            withdrawingTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var withdrawingValueLabel: TitleLabel!
   
    @IBOutlet weak var addressTextField: DesignableUITextField! {
        didSet {
            addressTextField.keyboardType = .default
            addressTextField.clearButtonMode = .whileEditing
        }
    }
    
    @IBOutlet weak var twoFactorStackView: UIStackView! {
        didSet {
            twoFactorStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var twoFactorTextField: DesignableUITextField! {
        didSet {
            twoFactorTextField.placeholder = "Two factor code"
            twoFactorTextField.keyboardType = .numberPad
            twoFactorTextField.clearButtonMode = .whileEditing
        }
    }
    
    @IBOutlet weak var withdrawButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bottomViewType = .none
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        withdrawButton.setEnabled(false)
        AuthManager.twoFactorEnabled { [weak self] (success) in
            self?.twoFactorStackView.isHidden = !success
        }
        
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
        if let selectedWallet = viewModel.selectedWallet, let commission = selectedWallet.commission, let currency = selectedWallet.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            
            if let description = selectedWallet._description {
                selectedWalletCurrencyValueLabel.text = description + " | " + currency.rawValue
            }
            
            self.feeValueLabel.text = commission.rounded(with: currencyType).toString() + " " + currency.rawValue
            
            if amountToWithdrawValue > commission {
                var value = amountToWithdrawValue - commission
                value = value > 0.0 ? value : 0.0
                
                self.withdrawingValueLabel.text = value.rounded(with: currencyType).toString() + " " + currency.rawValue
            } else {
                self.withdrawingValueLabel.text = "0 " + currency.rawValue
            }
            
            viewModel.walletCurrencyDelegateManager?.selectedWallet = selectedWallet
        }
        
        if let currency = viewModel.selectedWallet?.currency {
            self.amountToWithdrawCurrencyLabel.text = currency.rawValue
        }
        
        if let availableToWithdrawal = viewModel.selectedWallet?.availableToWithdrawal {
            self.availableInWalletValue = availableToWithdrawal
        }
        
        if let walletCurrencyDelegateManager = viewModel?.walletCurrencyDelegateManager {
            walletCurrencyDelegateManager.currencyDelegate = self
        }
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue <= availableInWalletValue
        withdrawButton?.setEnabled(withdrawButtonEnabled)
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 500
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()

        var amountText = ""
        
        if let amountToWithdrawValueLabel = amountToWithdrawValueLabel.text, let amountToWithdrawCurrency = amountToWithdrawCurrencyLabel.text {
            amountText = amountToWithdrawValueLabel + " " + amountToWithdrawCurrency
        }
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm withdraw",
                                                          subtitle: "Check again because the transaction cannot be reversed",
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: "Withdraw amount",
                                                          firstValue: amountText,
                                                          secondTitle: "To address",
                                                          secondValue: addressTextField.text,
                                                          thirdTitle: feeTitleLabel.text,
                                                          thirdValue: feeValueLabel.text,
                                                          fourthTitle: withdrawingTitleLabel.text,
                                                          fourthValue: withdrawingValueLabel.text)
        confirmView.configure(model: confirmViewModel)
        bottomSheetController.addContentsView(confirmView)
        confirmView.delegate = self
        bottomSheetController.present()
    }
    
    private func withdrawMethod() {
        hideKeyboard()
        
        guard amountToWithdrawValue > 0,
            let address = addressTextField.text,
            let twoFactorCode = twoFactorTextField.text,
            let selectedWallet = viewModel.selectedWallet,
            let currency = Currency(rawValue: selectedWallet.currency?.rawValue ?? "")
            else { return showErrorHUD(subtitle: "Enter withdraw amount and data, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amountToWithdrawValue, address: address, currency: currency, twoFactorCode: twoFactorCode) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.showSuccessfulView()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func showSuccessfulView() {
        showBottomSheet(.success, title: "Please approve the withdrawal request via the link in the confirmation email.", subtitle: nil, initializeHeight: 400) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.viewModel.goToBack()
                self?.bottomSheetController.dismiss()
            }
        }
    }
    
    @objc private func hideNumpadView() {
        numpadHeightConstraint.constant = 0.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        showConfirmVC()
    }
    
    @IBAction func readQRCodeButtonAction(_ sender: UIButton) {
        readerVC.delegate = self
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        amountToWithdrawValueLabel.text = availableInWalletValue.toString()
        amountToWithdrawValue = availableInWalletValue
    }
    
    @IBAction func showNumPadButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        numpadHeightConstraint.constant = 212.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    @IBAction func selectedWalletCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        viewModel?.walletCurrencyDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0
        
        bottomSheetController.addNavigationBar(selectedWalletCurrencyTitleLabel.text)
        
        bottomSheetController.addTableView { [weak self] tableView in
            self?.viewModel.walletCurrencyDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let walletCurrencyDelegateManager = self?.viewModel.walletCurrencyDelegateManager else { return }
            tableView.registerNibs(for: walletCurrencyDelegateManager.cellModelsForRegistration)
            tableView.delegate = walletCurrencyDelegateManager
            tableView.dataSource = walletCurrencyDelegateManager
        }
        
        bottomSheetController.present()
    }
}

extension WalletWithdrawViewController: WalletCurrencyDelegateManagerProtocol {
    func didSelectWallet(at indexPath: IndexPath) {
        self.viewModel.updateWalletCurrencyIndex(indexPath.row)
        self.updateUI()
        
        bottomSheetController.dismiss()
    }
}

extension WalletWithdrawViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        notificationFeedback()
        
        self.addressTextField.text = result.value
        reader.dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
}

extension WalletWithdrawViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return availableInWalletValue
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        if let currency = viewModel.selectedWallet?.currency {
            return CurrencyType(rawValue: currency.rawValue)
        }
        
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToWithdrawValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value, value <= availableInWalletValue else { return }
        
        numpadView.isEnable = true
        amountToWithdrawValue = value
    }
}

extension WalletWithdrawViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        withdrawMethod()
    }
}

extension WalletWithdrawViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
