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
    @IBOutlet var availableFundsLabel: UILabel!  {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAllTokensButtonAction))
            tapGesture.numberOfTapsRequired = 1
            availableFundsLabel.isUserInteractionEnabled = true
            availableFundsLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet var availableFundsCurrencyLabel: UILabel!
    @IBOutlet var amountLabel: UILabel! {
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
            if let investedTokens = viewModel.investedTokens {
                withdrawButton(enable: enteredAmount > 0.0 && enteredAmount <= investedTokens)
            }
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
        
        withdrawButton(enable: false)
        
        guard let investedTokens = viewModel.investedTokens else { return }
        availableFundsLabel.text = investedTokens.toString()
    }
    
    private func withdrawButton(enable: Bool) {
        withdrawButton.isUserInteractionEnabled = enable
        withdrawButton.backgroundColor = enable ? UIColor.Button.primary : UIColor.Button.gray
    }
    
    private func withdrawMethod() {
        hideKeyboard()
        
        guard let text = amountLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter withdraw value, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amount) { [weak self] (result) in
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
    
    @objc private func copyAllTokensButtonAction() {
        guard let investedTokens = viewModel.investedTokens else { return }
        
        amountLabel.text = investedTokens.toString()
        
        if let value = amountLabel.text?.doubleValue {
            enteredAmount = value
        }
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        withdrawMethod()
    }
}

extension ProgramWithdrawViewController: NumpadViewProtocol {
    var textLabel: UILabel {
        return self.amountLabel
    }
    
    func textLabelDidChange(value: Double?) {
        enteredAmount = value != nil ? value! : 0.0
    }
}
