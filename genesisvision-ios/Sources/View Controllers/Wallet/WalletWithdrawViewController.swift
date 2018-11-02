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
            self.availableInWalletValueLabel.text = availableInWalletValue.rounded(withType: .gvt).toString() + " " + Constants.gvtString
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var numpadHeightConstraint: NSLayoutConstraint! {
        didSet {
            numpadHeightConstraint.constant = 0.0
        }
    }
    @IBOutlet var numpadBackView: UIView! {
        didSet {
            numpadBackView.isHidden = true
            numpadBackView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideNumpadView))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.delegate = self
            numpadBackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    @IBOutlet var availableInWalletValueTitleLabel: TitleLabel! {
        didSet {
            availableInWalletValueTitleLabel.text = "Available in wallet"
            availableInWalletValueTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var availableInWalletValueLabel: TitleLabel! {
        didSet {
            availableInWalletValueLabel.textColor = UIColor.primary
            availableInWalletValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var amountToWithdrawTitleLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawTitleLabel.text = "Enter correct amount"
        }
    }
    @IBOutlet var amountToWithdrawValueLabel: TitleLabel! {
        didSet {
            amountToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToWithdrawGVTLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawGVTLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet var selectedWalletCurrencyButton: UIButton!
    @IBOutlet var selectedWalletCurrencyTitleLabel: SubtitleLabel! {
        didSet {
            selectedWalletCurrencyTitleLabel.text = "Select a wallet currency"
        }
    }
    @IBOutlet var selectedWalletCurrencyValueLabel: TitleLabel! {
        didSet {
            selectedWalletCurrencyValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet var scanQRButton: UIButton! {
        didSet {
            scanQRButton.setTitleColor(UIColor.Cell.title, for: .normal)
            scanQRButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet var feeTitleLabel: SubtitleLabel! {
        didSet {
            feeTitleLabel.text = "Fee"
            feeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var feeValueLabel: TitleLabel!
    @IBOutlet var withdrawingTitleLabel: SubtitleLabel! {
        didSet {
            withdrawingTitleLabel.text = "Approximate amount"
            withdrawingTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var withdrawingValueLabel: TitleLabel!
   
    @IBOutlet weak var addressTextField: DesignableUITextField! {
        didSet {
            addressTextField.keyboardType = .default
            addressTextField.clearButtonMode = .whileEditing
        }
    }
    
    @IBOutlet var twoFactorStackView: UIStackView! {
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
    
    @IBOutlet var withdrawButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bottomViewType = .dateRange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if let selectedWallet = viewModel.selectedWallet, let commission = selectedWallet.commission, let currency = selectedWallet.currency {
            let currency = CurrencyType(rawValue: currency.rawValue) ?? .gvt
            
            if let description = selectedWallet.description {
                selectedWalletCurrencyValueLabel.text = description + " | " + currency.rawValue
            }
            
            self.feeValueLabel.text = commission.rounded(withType: currency).toString() + " " + currency.rawValue
            
            if let rate = selectedWallet.rateToGvt, amountToWithdrawValue > commission {
                var getValue = amountToWithdrawValue * rate - commission
                getValue = getValue > 0.0 ? getValue : 0.0
                
                let amountToWithdrawValueCurrencyString = getValue.rounded(withType: currency).toString()
                self.withdrawingValueLabel.text = amountToWithdrawValueCurrencyString + " " + currency.rawValue
            } else {
                self.withdrawingValueLabel.text = "0 " + currency.rawValue
            }
            
            withdrawingTitleLabel.text = currency == .gvt ? "You will get" : "Approximate amount"
        }
        
        if let availableToWithdrawal = viewModel.withdrawalSummary?.availableToWithdrawal {
            self.availableInWalletValue = availableToWithdrawal
        }
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue <= availableInWalletValue
        withdrawButton?.setEnabled(withdrawButtonEnabled)
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 500
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()

        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Withdraw",
                                                          subtitle: "Check again because the transaction cannot be reversed",
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: "Withdraw amount",
                                                          firstValue: amountToWithdrawValueLabel.text,
                                                          secondTitle: "To address",
                                                          secondValue: addressTextField.text,
                                                          thirdTitle: withdrawingTitleLabel.text,
                                                          thirdValue: withdrawingValueLabel.text,
                                                          fourthTitle: feeTitleLabel.text,
                                                          fourthValue: feeValueLabel.text)
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
            let currency = CreateWithdrawalRequestModel.Currency(rawValue: selectedWallet.currency?.rawValue ?? "")
            else { return showErrorHUD(subtitle: "Enter withdraw amount and data, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amountToWithdrawValue, address: address, currency: currency, twoFactorCode: twoFactorCode) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showWalletWithdrawRequested()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
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
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        
        var selectedIndexRow = viewModel.selectedWalletCurrencyIndex
        let values = viewModel.walletCurrencyValues()
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            selectedIndexRow = index.row
            self?.viewModel.updateWalletCurrencyIndex(selectedIndexRow)
            
            self?.updateUI()
         }
        
        alert.addAction(title: "Ok", style: .cancel)
        
        alert.show()
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
    var amountLimit: Double? {
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
    
    var enteredAmountValue: Double {
        return amountToWithdrawValue
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
