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
            self.availableInWalletValueLabel.text = availableInWalletValue.toString() + " " + Constants.gvtString
        }
    }
    
    // MARK: - View Model
    var viewModel: WalletWithdrawViewModel!
    
    // MARK: - Outlets
    @IBOutlet var availableInWalletValueTitleLabel: TitleLabel! {
        didSet {
            availableInWalletValueTitleLabel.text = "Availible in wallet"
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
    @IBOutlet var amountToWithdrawCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawCurrencyLabel.textColor = UIColor.Cell.title
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
    
    @IBOutlet var copyMaxValueButton: UIButton!
    
    @IBOutlet var feeTitleLabel: SubtitleLabel! {
        didSet {
            feeTitleLabel.text = "Fee"
            feeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var feeValueLabel: TitleLabel!
    @IBOutlet var withdrawingTitleLabel: SubtitleLabel! {
        didSet {
            withdrawingTitleLabel.text = "Withdrawing"
            withdrawingTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var withdrawingValueLabel: TitleLabel!
    
    @IBOutlet weak var amountToWithdrawTextField: UITextField! {
        didSet {
            amountToWithdrawTextField.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var addressTextField: UITextField! {
        didSet {
            addressTextField.keyboardType = .default
            addressTextField.textColor = UIColor.Cell.title
            addressTextField.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet var withdrawButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
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
//        if let availableInWalletValue = viewModel.programWithdrawInfo?.availableToWithdraw {
//            self.availableInWalletValue = availableInWalletValue
//        }
        
//        if let fee = viewModel.programWithdrawInfo?.periodEnds {
//            self.feeValueLabel.text = fee
//        }
        
//        if let rate = viewModel.programWithdrawInfo?.rate {
//            let selectedCurrency = getSelectedCurrency()
//            let currency = CurrencyType(rawValue: selectedCurrency) ?? .gvt
//            let amountToWithdrawValueCurrencyString = (amountToWithdrawValue / rate).rounded(withType: currency).toString()
//            self.amountToWithdrawCurrencyLabel.text = "= " + amountToWithdrawValueCurrencyString + " " + selectedCurrency
//        }
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue <= availableInWalletValue
        withdrawButton?.setEnabled(withdrawButtonEnabled)
//        updateNumPadState(value: amountToWithdrawValueLabel.text)
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 400
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
        
        var commissionValue = ""
        if let commission = viewModel.selectedWallet?.commission {
            commissionValue = commission.toString()
        }
        
        var estimatedAmountValue = ""
        if let estimatedAmount = viewModel.estimatedAmount {
            estimatedAmountValue = estimatedAmount.toString()
        }
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Withdraw",
                                                          subtitle: "Check again because the transaction cannot be reversed",
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: "Withdraw amount",
                                                          firstValue: amountToWithdrawValueLabel.text,
                                                          secondTitle: "To address",
                                                          secondValue: addressTextField.text,
                                                          thirdTitle: "Estimated amount",
                                                          thirdValue: estimatedAmountValue,
                                                          fourthTitle: "Fee",
                                                          fourthValue: commissionValue)
        confirmView.configure(model: confirmViewModel)
        bottomSheetController.addContentsView(confirmView)
        confirmView.delegate = self
        bottomSheetController.present()
    }
    
    private func withdrawMethod() {
        hideKeyboard()
        
        guard let amountToWithdrawText = amountToWithdrawTextField.text,
            let amountToWithdrawValue = amountToWithdrawText.doubleValue,
            let address = addressTextField.text
            else { return showErrorHUD(subtitle: "Enter withdraw amount and data, please") }
        
        showProgressHUD()
        //TODO:!!!!
        let twoFactorCode = ""
        viewModel.withdraw(with: amountToWithdrawValue, address: address, currency: .gvt, twoFactorCode: twoFactorCode) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showWalletWithdrawRequested()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
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
        amountToWithdrawValueLabel.text = availableInWalletValue.toString(withoutFormatter: true)
        amountToWithdrawValue = availableInWalletValue
    }
    
    @IBAction func selectedWalletCurrencyButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.primary
        
        var selectedIndexRow = viewModel.selectedWalletCurrencyIndex
        let values = viewModel.walletCurrencyValues()
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            selectedIndexRow = index.row
            self?.viewModel.updateWalletCurrencyIndex(selectedIndexRow)
        }
        
        alert.addAction(title: "Cancel", style: .cancel)
        
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

extension WalletWithdrawViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        withdrawMethod()
    }
}
