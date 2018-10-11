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
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    // MARK: - Labels
    @IBOutlet var availableToInvestTitleLabel: TitleLabel! {
        didSet {
            availableToInvestTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var availableToInvestValueLabel: TitleLabel! {
        didSet {
            availableToInvestValueLabel.textColor = UIColor.primary
            availableToInvestValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var amountToInvestTitleLabel: SubtitleLabel! 
    @IBOutlet var amountToInvestValueLabel: TitleLabel! {
        didSet {
            amountToInvestValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToInvestCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToInvestCurrencyLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var copyMaxValueButton: UIButton!
    
    @IBOutlet var entryFeeTitleLabel: SubtitleLabel! {
        didSet {
            entryFeeTitleLabel.text = "Entry fee"
            entryFeeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var entryFeeValueLabel: TitleLabel!
    
    @IBOutlet var amountDueTitleLabel: SubtitleLabel! {
        didSet {
            amountDueTitleLabel.text = "Amount due"
            amountDueTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var amountDueValueLabel: TitleLabel!

    // MARK: - Buttons
    @IBOutlet var investButton: ActionButton!

    private var closeBarButtonItem: UIBarButtonItem!
    
    // MARK: - Variables
    var availableToInvestValue: Double = 0.0 {
        didSet {
            self.availableToInvestValueLabel.text = availableToInvestValue.toString() + " GVT"
        }
    }
    
    var amountToInvestValue: Double = 0.0 {
        didSet {
            viewModel.getExchangedAmount(amount: amountToInvestValue, completion: { [weak self] (amountToInvestValueCurrency) in
                DispatchQueue.main.async {
                    let selectedCurrency = getSelectedCurrency()
                    self?.amountToInvestCurrencyLabel.text = "= \(amountToInvestValueCurrency.toString()) \(selectedCurrency)"
                }
            }) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
            
            investButton.setEnabled(amountToInvestValue > 0 && amountToInvestValue <= amountToInvestValue)
            updateNumPadState(value: amountToInvestValueLabel.text)
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
        closeBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_close_icon"), style: .done, target: self, action: #selector(closeButtonAction))
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
        investButton.setEnabled(false)
        showProgressHUD()
        
        viewModel.getAvailableToInvest(completion: { [weak self] (amountToInvestValue, amountToInvestValueCurrency) in
            self?.hideAll()
            self?.availableToInvestValue = amountToInvestValue
        }) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
    }
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func investMethod() {
        hideKeyboard()
        
        guard let text = amountToInvestValueLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter investment value, please") }
        
        showProgressHUD()
        viewModel.invest(with: amount) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showInvestmentRequestedVC(investedAmount: amount)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func updateNumPadState(value: String?) {
        if let text = value, text.range(of: ".") != nil,
            let lastComponents = text.components(separatedBy: ".").last,
            lastComponents.count >= getDecimalCount(for: currency) {
            changedActive(value: false)
        } else {
            changedActive(value: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: UIButton) {
        investMethod()
    }
    
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        amountToInvestValueLabel.text = availableToInvestValue.toString(withoutFormatter: true)
        amountToInvestValue = availableToInvestValue
    }
    
}

extension ProgramInvestViewController: NumpadViewProtocol {
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int {
        return -1
    }
    
    var currency: String? {
        return Constants.currency
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToInvestValueLabel
    }
    
    var enteredAmountValue: Double {
        return amountToInvestValue
    }
    
    func textLabelDidChange(value: Double?) {
        numpadView.isEnable = true
        amountToInvestValue = value != nil ? value! : 0.0
    }
}
