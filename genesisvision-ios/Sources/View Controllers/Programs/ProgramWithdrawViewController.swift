//
//  ProgramWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramWithdrawViewController: BaseViewController {

    var viewModel: ProgramWithdrawViewModel!
    
    // MARK: - Labels
    @IBOutlet var balanceLabel: UILabel!  {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAllButtonAction))
            tapGesture.numberOfTapsRequired = 1
            balanceLabel.isUserInteractionEnabled = true
            balanceLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet var balanceCurrencyLabel: UILabel!

    @IBOutlet var amountLabel: AmountLabel! {
        didSet {
            amountLabel.font = UIFont.getFont(.light, size: 72)
        }
    }
    @IBOutlet var amountCurrencyLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var withdrawButton: ActionButton!
    
    // MARK: - Views
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
        }
    }
    
    // MARK: - Variables
    var enteredAmount: Double = 0.0 {
        didSet {
            withdrawButton(enable: enteredAmount > 0.0 && enteredAmount <= investedTokens)
            updateNumPadState(value: amountLabel.text)
        }
    }
    
    var investedTokens: Double = 0.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Background.main
        navigationItem.setTitle(title: viewModel.title, subtitle: getVersion(), style: .primary)
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
        setupNavigationBar(with: .primary)
        
        withdrawButton(enable: false)
        
        if let investedTokens = viewModel.investedTokens {
            self.investedTokens = investedTokens
            balanceLabel.text = self.investedTokens.toString()
        }
        
        self.balanceCurrencyLabel.text = "tokens"
        self.amountCurrencyLabel.text = "tokens"
    }
    
    private func withdrawButton(enable: Bool) {
        withdrawButton.isUserInteractionEnabled = enable
        withdrawButton.backgroundColor = enable ? UIColor.Button.primary : UIColor.Button.primary.withAlphaComponent(0.3)
    }
    
    private func withdrawMethod() {
        hideKeyboard()
        
        guard let text = amountLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter withdraw value, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amount) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showWithdrawRequestedVC()
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
        amountLabel.text = investedTokens.toString(withoutFormatter: true)
        enteredAmount = investedTokens
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        withdrawMethod()
    }
}

extension ProgramWithdrawViewController: NumpadViewProtocol {
    var currency: String {
        return ""
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountLabel
    }
    
    func textLabelDidChange(value: Double?) {
        numpadView.isEnable = true
        enteredAmount = value != nil ? value! : 0.0
    }
}
