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
    @IBOutlet var withdrawButton: UIButton!
    
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
        availableFundsLabel.text = "Available funds: " + String(describing: viewModel.investedTokens) + "tokens"
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
