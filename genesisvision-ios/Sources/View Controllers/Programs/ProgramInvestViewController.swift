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
        }
    }
    
    // MARK: - Labels
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var balanceCurrencyLabel: UILabel!
    @IBOutlet var usdBalanceLabel: UILabel!
    @IBOutlet var amountLabel: AmountLabel! 
    
    @IBOutlet var amountCurrencyLabel: UILabel!
    @IBOutlet var usdAmountLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var investButton: UIButton!
    
    // MARK: - Variables
    var enteredAmount: Double = 0.0 {
        didSet {
            viewModel.getUSDAmountText(amount: enteredAmount) { [weak self] (usdAmountValue) in
                self?.usdAmountLabel.text = usdAmountValue
            }
            
            investButton(enable: enteredAmount > 0)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
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
        
        investButton(enable: false)
        
        viewModel.getBalanceText { [weak self] (balanceText, usdBalanceText) in
            self?.balanceLabel.text = balanceText
            self?.usdBalanceLabel.text = usdBalanceText
        }
    }
    
    private func investButton(enable: Bool) {
        investButton.isUserInteractionEnabled = enable
        investButton.backgroundColor = enable ? UIColor.Button.primary : UIColor.Button.gray
    }
    
    private func investMethod() {
        hideKeyboard()
        
        guard let text = amountLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter investment value, please") }
        
        showProgressHUD()
        viewModel.invest(with: amount) { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { (success) in
                    self?.viewModel.goToBack()
                })
            case .failure(let reason):
                self?.showErrorHUD(subtitle: reason)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: UIButton) {
        investMethod()
    }
}

extension ProgramInvestViewController: NumpadViewProtocol {
    var textLabel: UILabel {
        return self.amountLabel
    }
    
    func textLabelDidChange(value: Double?) {
        enteredAmount = value != nil ? value! : 0.0
    }
}
