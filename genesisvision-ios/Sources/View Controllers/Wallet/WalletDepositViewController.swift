//
//  WalletDepositViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletDepositViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: WalletDepositViewModel!
    
    // MARK: - Variables
    var amountToDepositValue: Double = 0.0 {
        didSet {
            updateUI()
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
    
    @IBOutlet var amountToDepositTitleLabel: SubtitleLabel! {
        didSet {
            amountToDepositTitleLabel.text = "You will send"
        }
    }
    @IBOutlet var amountToDepositValueLabel: TitleLabel! {
        didSet {
            amountToDepositValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet var amountToDepositCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToDepositCurrencyLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet var amountToDepositGVTTitleLabel: SubtitleLabel! {
        didSet {
            amountToDepositGVTTitleLabel.text = "Approximate amount"
            amountToDepositGVTTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var amountToDepositGVTValueLabel: TitleLabel!
    
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
    
    @IBOutlet var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.font = UIFont.getFont(.regular, size: 10.0)
        }
    }
    
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var addressLabel: TitleLabel!
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
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
        addressLabel.isHidden = false
        addressLabel.text = viewModel.getAddress()
        qrImageView.image = viewModel.getQRImage()
        
        if let selectedWallet = viewModel.selectedWallet, let currency = selectedWallet.currency, let rateToGVT = selectedWallet.rateToGVT {
            let currency = CurrencyType(rawValue: currency.rawValue) ?? .gvt
            
            amountToDepositCurrencyLabel.text = currency.rawValue
            
            amountToDepositGVTValueLabel.text = (amountToDepositValue / rateToGVT).rounded(withType: .gvt).toString() + " " + Constants.gvtString
            
            if let description = selectedWallet.description {
                selectedWalletCurrencyValueLabel.text = description + " | " + currency.rawValue
            }
            
            if currency != .gvt {
                disclaimerLabel.isHidden = false
                disclaimerLabel.text = "After processing the \(currency.rawValue) transaction, your transferred funds will be converted to GVT, according to the current market price. The exact amount of GVT received will be determined at the time of conversion in the market."
                amountToDepositGVTTitleLabel.text = "Approximate amount"
            } else {
                disclaimerLabel.isHidden = true
                amountToDepositGVTTitleLabel.text = "You will get"
            }
        }
        
        self.view.layoutIfNeeded()
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
    @IBAction func showNumPadButtonAction(_ sender: UIButton) {
        numpadHeightConstraint.constant = 212.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    @IBAction func copyButtonAction(_ sender: UIButton) {
        showProgressHUD()
        viewModel.copy { [weak self] (result) in
            self?.hideAll()
            self?.showBottomSheet(type: .success, title: self?.viewModel.successText)
        }
    }
    
    @IBAction func selectedWalletCurrencyButtonAction(_ sender: UIButton) {
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

extension WalletDepositViewController: NumpadViewProtocol {
    var amountLimit: Double? {
        return nil
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
        return self.amountToDepositValueLabel
    }
    
    var enteredAmountValue: Double {
        return amountToDepositValue
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value else { return }
        
        numpadView.isEnable = true
        amountToDepositValue = value
    }
}

extension WalletDepositViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
