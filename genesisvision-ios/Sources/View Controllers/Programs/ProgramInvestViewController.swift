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
    @IBOutlet var amountTextField: DesignableUITextField! {
        didSet {
            amountTextField.isUserInteractionEnabled = false
            amountTextField.font = UIFont.getFont(.light, size: 72)
        }
    }
    
    // MARK: - Views
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
        }
    }
    
    // MARK: - Labels
    @IBOutlet var balanceLabel: UILabel!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
        navigationController?.navigationBar.barTintColor = UIColor.NavBar.background
        navigationController?.navigationBar.tintColor = UIColor.Font.primary
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.dark,
                                                            NSAttributedStringKey.font: UIFont.getFont(.bold, size: 18)]
    }
    
    
    // MARK: - Private methods
    private func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor.Font.primary
        navigationController?.navigationBar.tintColor = UIColor.Font.white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.Font.white,
                                                            NSAttributedStringKey.font: UIFont.getFont(.bold, size: 18)]
        
        viewModel.getAmountText { [weak self] (text) in
            self?.balanceLabel.text = text
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

extension ProgramInvestViewController: NumpadViewProtocol {
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
