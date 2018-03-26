//
//  ProgramWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramWithdrawViewController: UIViewController {

    var viewModel: ProgramWithdrawViewModel!
    
    // MARK: - TextFields
    @IBOutlet var amountTextField: UITextField!
    
    // MARK: - Labels
    @IBOutlet var availableFundsLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var withdrawButton: UIButton! {
        didSet {
            withdrawButton(enable: false)
        }
    }
    
    // MARK: - Views
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
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
    
    // MARK: - Private methods
    private func setupUI() {
        guard let investedTokens = viewModel.investedTokens else { return }
        availableFundsLabel.text = "Available funds: " + investedTokens.toString() + " tokens"
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let investedTokens = viewModel.investedTokens, let value = textField.text?.doubleValue else {
            return withdrawButton(enable: false)
        }
        
        withdrawButton(enable: value > 0.0 && value <= investedTokens)
    }
    
    private func withdrawButton(enable: Bool) {
        withdrawButton.isUserInteractionEnabled = enable
        withdrawButton.backgroundColor = enable ? UIColor.Button.primary : UIColor.Button.gray
    }
    
    private func withdrawMethod() {
        hideKeyboard()
        
        guard let text = amountTextField.text,
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
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        withdrawMethod()
    }
}

extension ProgramWithdrawViewController: NumpadViewProtocol {
    func onClearClicked(view: NumpadView) {
        guard let text = amountTextField.text, !text.isEmpty else { return }
        
        guard text != "0," else {
            amountTextField.text?.removeAll()
            return
        }
        
        amountTextField.text?.removeLast(1)
    }
    
    func onSeparatorClicked(view: NumpadView) {
        guard let text = amountTextField.text else { return }
        
        guard text.range(of: ",") == nil else {
            return
        }
        
        guard !text.isEmpty else {
            amountTextField.text?.append("0,")
            return
        }
        
        amountTextField.text?.append(",")
    }
    
    func onNumberClicked(view: NumpadView, value: Int) {
        guard let text = amountTextField.text else { return }
        
        if text.isEmpty && value == 0 {
            amountTextField.text?.append("0,")
            return
        }
        
        amountTextField.text?.append(value.toString())
    }
}
