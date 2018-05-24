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
            emailTextField.font = UIFont.getFont(.regular, size: 18)
            emailTextField.setClearButtonWhileEditing()
            emailTextField.setLeftImageView()
            emailTextField.delegate = self
        }
    }
    @IBOutlet var passwordTextField: DesignableUITextField! {
        didSet {
            passwordTextField.font = UIFont.getFont(.regular, size: 18)
            passwordTextField.setClearButtonWhileEditing()
            passwordTextField.setLeftImageView()
            passwordTextField.delegate = self
        }
    }
    @IBOutlet var confirmPasswordTextField: DesignableUITextField! {
        didSet {
            confirmPasswordTextField.font = UIFont.getFont(.regular, size: 18)
            confirmPasswordTextField.setClearButtonWhileEditing()
            confirmPasswordTextField.setLeftImageView()
            confirmPasswordTextField.delegate = self
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var signUpButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
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
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showConfirmationVC()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
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
