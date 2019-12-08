//
//  WalletTransferViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 20.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import AVFoundation

class WalletTransferViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: WalletTransferViewModel!
    
    // MARK: - Variables
    var amountToTransferValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var availableInWalletFromValue: Double = 0.0 {
        didSet {
            if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                self.availableInWalletFromValueLabel.text = availableInWalletFromValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
            }
        }
    }
    
    var availableInWalletToValue: Double = 0.0 {
        didSet {
            if let currency = viewModel.selectedWalletToDelegateManager?.selected?.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                self.availableInWalletToValueLabel.text = availableInWalletToValue.rounded(with: currencyType).toString() + " " + currencyType.rawValue
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
    //From
    @IBOutlet weak var transferToWalletFromTitleLabel: SubtitleLabel! {
        didSet {
            transferToWalletFromTitleLabel.text = "From"
        }
    }
    @IBOutlet weak var selectedWalletFromButton: UIButton!
    @IBOutlet weak var selectedWalletFromValueLabel: TitleLabel! {
        didSet {
            selectedWalletFromValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var availableInWalletFromTitleLabel: SubtitleLabel! {
        didSet {
            availableInWalletFromTitleLabel.text = "Available in wallet"
        }
    }
    @IBOutlet weak var availableInWalletFromValueLabel: TitleLabel! {
        didSet {
            availableInWalletFromValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    //To
    @IBOutlet weak var transferToWalletToTitleLabel: SubtitleLabel! {
        didSet {
            transferToWalletToTitleLabel.text = "To"
        }
    }
    @IBOutlet weak var selectedWalletToButton: UIButton!
    @IBOutlet weak var selectedWalletToValueLabel: TitleLabel! {
        didSet {
            selectedWalletToValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var availableInWalletToTitleLabel: SubtitleLabel! {
        didSet {
            availableInWalletToTitleLabel.text = "Available in wallet"
        }
    }
    @IBOutlet weak var availableInWalletToValueLabel: TitleLabel! {
        didSet {
            availableInWalletToValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var amountToTransferTitleLabel: SubtitleLabel! {
        didSet {
            amountToTransferTitleLabel.text = "Enter correct amount"
        }
    }
    @IBOutlet weak var amountToTransferFromValueLabel: TitleLabel! {
        didSet {
            amountToTransferFromValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var amountToTransferFromCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToTransferFromCurrencyLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    @IBOutlet weak var amountToTransferToValueLabel: SubtitleLabel!
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.text = viewModel.disclaimer
            
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
            disclaimerLabel.textAlignment = .justified
        }
    }
    
    @IBOutlet weak var transferButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bottomViewType = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showProgressHUD()
        updateUI()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        transferButton.setEnabled(false)
    }
    
    private func updateUI() {
        guard let selectedWalletFrom = viewModel.selectedWalletFromDelegateManager?.selected, let selectedWalletTo = viewModel.selectedWalletToDelegateManager?.selected else { return }
        
        if let title = selectedWalletFrom.title, let currency = selectedWalletFrom.currency?.rawValue {
            selectedWalletFromValueLabel.text = title + " | " + currency
            amountToTransferFromCurrencyLabel.text = currency
        }
        
        if let to = selectedWalletTo.currency?.rawValue, let title = selectedWalletTo.title,  let currencyType = CurrencyType(rawValue: to) {
            selectedWalletToValueLabel.text = title + " | " + to
            
            let value = (amountToTransferValue * viewModel.rate).rounded(with: currencyType).toString()
            amountToTransferToValueLabel.text = "≈" + value + " " + currencyType.rawValue
        }
        
        if let available = selectedWalletFrom.available {
            self.availableInWalletFromValue = available
        }
        
        if let available = selectedWalletTo.available {
            self.availableInWalletToValue = available
        }
        
        if let selectedWalletFromDelegateManager = viewModel?.selectedWalletFromDelegateManager {
            selectedWalletFromDelegateManager.currencyDelegate = self
        }
        
        if let selectedWalletToDelegateManager = viewModel?.selectedWalletToDelegateManager {
            selectedWalletToDelegateManager.currencyDelegate = self
        }
        
        let transferButtonEnabled = amountToTransferValue > 0.0 && amountToTransferValue <= availableInWalletFromValue
        transferButton?.setEnabled(transferButtonEnabled)
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 450
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
 
        var amountText = ""
        
        if let amountToTransferFromValue = amountToTransferFromValueLabel.text, let amountToTransferFromCurrency = amountToTransferFromCurrencyLabel.text, let amountToTransferToValue = amountToTransferToValueLabel.text {
            amountText = amountToTransferFromValue + " " + amountToTransferFromCurrency + " " + amountToTransferToValue
        }
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm transfer",
                                                          subtitle: disclaimerLabel.text,
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: "Transfer amount",
                                                          firstValue: amountText,
                                                          secondTitle: transferToWalletFromTitleLabel.text,
                                                          secondValue: selectedWalletFromValueLabel.text,
                                                          thirdTitle: transferToWalletToTitleLabel.text,
                                                          thirdValue: selectedWalletToValueLabel.text,
                                                          fourthTitle: nil,
                                                          fourthValue: nil)
        confirmView.configure(model: confirmViewModel)
        bottomSheetController.addContentsView(confirmView)
        confirmView.delegate = self
        bottomSheetController.present()
    }
    
    private func transferMethod() {
        hideKeyboard()
        
        guard amountToTransferValue > 0 else { return showErrorHUD(subtitle: "Enter correct amount, please") }
        
        showProgressHUD()
        viewModel.transfer(with: amountToTransferValue) { [weak self] (result) in
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
        showBottomSheet(.success, title: "Conversion successful", subtitle: nil, initializeHeight: 250.0) { [weak self] (result) in
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
    @IBAction func transferButtonAction(_ sender: UIButton) {
        showConfirmVC()
    }
    
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        amountToTransferFromValueLabel.text = availableInWalletFromValue.toString()
        amountToTransferValue = availableInWalletFromValue
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
    
    @IBAction func selectedWalletCurrencyFromButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        viewModel?.selectedWalletFromDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0
        
        bottomSheetController.addNavigationBar(transferToWalletFromTitleLabel.text)
        
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
    
    @IBAction func selectedWalletCurrencyToButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        viewModel?.selectedWalletToDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0
        
        bottomSheetController.addNavigationBar(transferToWalletToTitleLabel.text)
        
        bottomSheetController.addTableView { [weak self] tableView in
            self?.viewModel.selectedWalletToDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let selectedWalletToDelegateManager = self?.viewModel.selectedWalletToDelegateManager else { return }
            tableView.registerNibs(for: selectedWalletToDelegateManager.cellModelsForRegistration)
            tableView.delegate = selectedWalletToDelegateManager
            tableView.dataSource = selectedWalletToDelegateManager
        }
        
        bottomSheetController.present()
    }
}

extension WalletTransferViewController: WalletDelegateManagerProtocol {
    func didSelectWallet(at indexPath: IndexPath, walletId: Int) {
        switch walletId {
        case 1:
            self.viewModel.updateWalletCurrencyToIndex(indexPath.row) { [weak self] (result) in
                switch result {
                case .success:
                    self?.updateUI()
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        default:
            self.viewModel.updateWalletCurrencyFromIndex(indexPath.row) { [weak self] (result) in
                switch result {
                case .success:
                    self?.updateUI()
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        }
        
        bottomSheetController.dismiss()
    }
}

extension WalletTransferViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return availableInWalletFromValue
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        if let currency = viewModel.selectedWalletFromDelegateManager?.selected?.currency {
            return CurrencyType(rawValue: currency.rawValue)
        }
        
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToTransferFromValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value, value <= availableInWalletFromValue else { return }
        
        numpadView.isEnable = true
        amountToTransferValue = value
    }
}

extension WalletTransferViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        transferMethod()
    }
}

extension WalletTransferViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

extension WalletTransferViewController: WalletProtocol {
    func didUpdateData() {
        hideAll()
    }
}
