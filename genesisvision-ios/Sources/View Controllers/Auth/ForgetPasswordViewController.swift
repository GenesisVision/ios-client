//
//  ForgotPasswordViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ForgotPasswordViewController: BaseViewController {
    
    var viewModel: AuthForgetPasswordViewModel!
    
    // MARK: - TextFields
    @IBOutlet var emailTextField: DesignableUITextField! {
        didSet {
            emailTextField.font = UIFont.getFont(.regular, size: 18)
            emailTextField.setClearButtonWhileEditing()
            emailTextField.setLeftImageView()
            emailTextField.delegate = self
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var resetButtonButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
        emailTextField.text = "george@genesis.vision"
        #endif
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        emailTextField.setBottomLine()
    }
    
    private func resetButtonMethod() {
        hideKeyboard()
        showProgressHUD()
        
        var email = emailTextField.text ?? ""
        
        email = email.trimmingCharacters(in: .whitespaces)
        
        viewModel.forgotPassword(email: email) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showForgotPasswordInfoVC()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func resetButtonAction(_ sender: UIButton) {
        resetButtonMethod()
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetButtonMethod()
        
        return false
    }
}
