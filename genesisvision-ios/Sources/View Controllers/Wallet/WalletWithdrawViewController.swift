//
//  WalletWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletWithdrawViewController: BaseViewController {
    
    // MARK: - Variables
    private var withdrawButton: UIButton?
    private var readQRCodeButton: UIButton?
    
    // MARK: - View Model
    var viewModel: WalletWithdrawViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.title
    }
    
    // MARK: - Private methods
    private func setup() {
        //Setup
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        hideKeyboard()
        showProgressHUD()
        
        guard let amountText = amountTextField.text,
            let amount = amountText.doubleValue,
            let address = addressTextField.text
            else { return }
        
        viewModel.withdraw(with: amount, address: address) { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { (success) in
                    self?.viewModel.goBack()
                })
            case .failure(let reason):
                self?.showErrorHUD(subtitle: reason)
            }
        }
    }
    
    @IBAction func readQRCodeButtonAction(_ sender: UIButton) {
        hideKeyboard()
        showProgressHUD()
        
        viewModel.readQRCode { [weak self] (result) in
            self?.hideHUD()
        }
    }
}

