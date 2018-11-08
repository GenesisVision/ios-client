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
    @IBOutlet var oldPasswordTitleLabel: SubtitleLabel! {
        didSet {
            oldPasswordTitleLabel.text = "Old password"
        }
    }
    @IBOutlet var oldPasswordTextField: DesignableUITextField! {
        didSet {
            oldPasswordTextField.setClearButtonWhileEditing()
            oldPasswordTextField.delegate = self
        }
    }
    @IBOutlet var passwordTitleLabel: SubtitleLabel! {
        didSet {
            passwordTitleLabel.text = "New password"
        }
    }
    @IBOutlet var passwordTextField: DesignableUITextField! {
        didSet {
            passwordTextField.setClearButtonWhileEditing()
            passwordTextField.delegate = self
        }
    }
    @IBOutlet var confirmPasswordTitleLabel: SubtitleLabel! {
        didSet {
            confirmPasswordTitleLabel.text = "Repeat password"
        }
    }
    @IBOutlet var confirmPasswordTextField: DesignableUITextField! {
        didSet {
            confirmPasswordTextField.setClearButtonWhileEditing()
            confirmPasswordTextField.delegate = self
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var changePasswordButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
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
                self?.showChangePasswordInfoVC()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func showChangePasswordInfoVC() {
        showBottomSheet(type: .success, title: viewModel.successText) { [weak self] (success) in
            self?.viewModel.goToBack()
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
