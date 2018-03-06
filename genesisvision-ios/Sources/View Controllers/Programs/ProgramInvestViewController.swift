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
    
    // MARK: - TextFields
    @IBOutlet var amountTextField: UITextField!
    
    // MARK: - Labels
    @IBOutlet var amountLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var investButton: UIButton!
    
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
        viewModel.getAmountText { [weak self] (text) in
            self?.amountLabel.text = text
        }
    }
    
    private func investMethod() {
        hideKeyboard()
        
        guard let text = amountTextField.text,
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
