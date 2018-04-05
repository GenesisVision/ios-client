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
    @IBOutlet var withdrawButton: UIButton!
    
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
        }
    }
    
    var investedTokens: Double = 0.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setTitle(title: viewModel.title, subtitle: getVersion())
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
                self?.showSuccessHUD(completion: { (success) in
                    self?.viewModel.goToBack()
                })
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    @objc private func copyAllButtonAction() {
        enteredAmount = investedTokens
        amountLabel.text = investedTokens.toString(withoutFormatter: true)
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
