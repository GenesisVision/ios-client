//
//  SignUpViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpViewController: BaseViewController {

    var viewModel: SignUpViewModel!
    
    // MARK: - TextFields
    @IBOutlet var emailTextField: DesignableUITextField! {
        didSet {
            emailTextField.setClearButtonWhileEditing()
            emailTextField.setLeftImageView()
            emailTextField.delegate = self
        }
    }
    @IBOutlet var passwordTextField: DesignableUITextField! {
        didSet {
            passwordTextField.setClearButtonWhileEditing()
            passwordTextField.setLeftImageView()
            passwordTextField.delegate = self
        }
    }
    @IBOutlet var confirmPasswordTextField: DesignableUITextField! {
        didSet {
            confirmPasswordTextField.setClearButtonWhileEditing()
            confirmPasswordTextField.setLeftImageView()
            confirmPasswordTextField.delegate = self
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var signUpButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
            emailTextField.text = "george@genesis.vision"
            passwordTextField.text = "qwerty"
            confirmPasswordTextField.text = "qwerty"
        #endif
        
        setupUI()
    }

    // MARK: - Private methods
    private func setupUI() {
        emailTextField.setBottomLine()
        passwordTextField.setBottomLine()
        confirmPasswordTextField.setBottomLine()
    }
    
    
    private func sighUpMethod() {
        hideKeyboard()
        showProgressHUD()
        
        viewModel.signUp(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: confirmPasswordTextField.text ?? "") { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { [weak self] (finish) in
                    self?.viewModel.showConfirmationVC()
                })
            case .failure(let reason):
                self?.showErrorHUD(subtitle: reason)
            }
        }
    }
    
    private func showConfirmationVC() {
        viewModel.showConfirmationVC()
    }
    
    // MARK: - Actions
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        sighUpMethod()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case confirmPasswordTextField:
            sighUpMethod()
        default:
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return false
    }
}
