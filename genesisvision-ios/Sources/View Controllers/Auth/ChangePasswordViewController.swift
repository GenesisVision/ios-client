//
//  ChangePasswordViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChangePasswordViewController: BaseViewController {
    
    var viewModel: AuthChangePasswordViewModel!
    
    // MARK: - TextFields
    @IBOutlet var oldPasswordTextField: DesignableUITextField! {
        didSet {
            oldPasswordTextField.font = UIFont.getFont(.regular, size: 18)
            oldPasswordTextField.setClearButtonWhileEditing()
            oldPasswordTextField.setLeftImageView()
            oldPasswordTextField.delegate = self
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
    @IBOutlet var changePasswordButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
        oldPasswordTextField.text = "qwerty"
        passwordTextField.text = "qwerty"
        confirmPasswordTextField.text = "qwerty"
        #endif
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        oldPasswordTextField.setBottomLine()
        passwordTextField.setBottomLine()
        confirmPasswordTextField.setBottomLine()
    }
    
    
    private func changePasswordMethod() {
        hideKeyboard()
        showProgressHUD()
        
        var oldPassword = oldPasswordTextField.text ?? ""
        var password = passwordTextField.text ?? ""
        var confirmPassword = confirmPasswordTextField.text ?? ""
        
        oldPassword = oldPassword.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        confirmPassword = confirmPassword.trimmingCharacters(in: .whitespaces)
        
        viewModel.changePassword(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showChangePasswordInfoVC()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func changePasswordButtonAction(_ sender: UIButton) {
        changePasswordMethod()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case confirmPasswordTextField:
            changePasswordMethod()
        default:
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return false
    }
}

