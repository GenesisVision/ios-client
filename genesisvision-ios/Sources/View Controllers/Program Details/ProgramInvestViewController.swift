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
    @IBOutlet var availableToInvestLabel: UILabel! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAllButtonAction))
            tapGesture.numberOfTapsRequired = 1
            availableToInvestLabel.isUserInteractionEnabled = true
            availableToInvestLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet var balanceCurrencyLabel: UILabel!
    @IBOutlet var exchangedAvailableToInvestLabel: UILabel!
    @IBOutlet var exchangedBalanceCurrencyLabel: UILabel!
    
    @IBOutlet var amountLabel: AmountLabel! {
        didSet {
            amountLabel.font = UIFont.getFont(.light, size: 72)
            amountLabel.text = viewModel.labelPlaceholder
        }
    }
    @IBOutlet var amountCurrencyLabel: UILabel!
    @IBOutlet var exchangedAmountLabel: UILabel!
    @IBOutlet var exchangedAmountCurrencyLabel: CurrencyLabel!
    
    // MARK: - Buttons
    @IBOutlet var investButton: ActionButton!
    
    // MARK: - Variables
    var balance: Double = 0.0 {
        didSet {
            self.availableToInvestLabel.text = balance.toString()
        }
    }
    var exchangedBalance: Double = 0.0 {
        didSet {
            self.exchangedAvailableToInvestLabel.text = exchangedBalance.toString()
        }
    }
    
    var enteredAmount: Double = 0.0 {
        didSet {
            viewModel.getExchangedAmount(amount: enteredAmount, completion: { [weak self] (exchangedAmountValue) in
                self?.exchangedAmountLabel.text = exchangedAmountValue.toString()
            }) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
            
            investButton.setEnabled(enteredAmount > 0 && enteredAmount <= balance)
            updateNumPadState(value: amountLabel.text)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion(), type: .primary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = UIColor.Background.main
        
        setupNavigationBar(with: .primary)
        
        investButton.setEnabled(false)
        showProgressHUD()
        
        viewModel.getAvailableToInvest(completion: { [weak self] (balance, exchangedBalance) in
            self?.hideAll()
            self?.balance = balance
            self?.exchangedBalance = exchangedBalance
        }) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType)
            }
        }
        
        self.balanceCurrencyLabel.text = "GVT"
        self.exchangedBalanceCurrencyLabel.text = viewModel.currency
        self.amountCurrencyLabel.text = "GVT"
        self.exchangedAmountCurrencyLabel.text = viewModel.currency
        
        if let currencyType = CurrencyType(currency: viewModel.currency) {
            self.exchangedAmountCurrencyLabel.currencyType = currencyType
        }
    }
    
    private func investMethod() {
        hideKeyboard()
        
        guard let text = amountLabel.text,
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
    
    @objc private func copyAllButtonAction() {
        amountLabel.text = balance.toString(withoutFormatter: true)
        enteredAmount = balance
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: UIButton) {
        investMethod()
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
        return self.amountLabel
    }
    
    var enteredAmountValue: Double {
        return enteredAmount
    }
    
    func textLabelDidChange(value: Double?) {
        numpadView.isEnable = true
        enteredAmount = value != nil ? value! : 0.0
    }
}
