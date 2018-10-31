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
    @IBOutlet var emailTitleLabel: SubtitleLabel! {
        didSet {
            emailTitleLabel.text = "Email"
        }
    }
    @IBOutlet var emailTextField: DesignableUITextField! {
        didSet {
            emailTextField.setClearButtonWhileEditing()
            emailTextField.delegate = self
        }
    }
    
    // MARK: - Buttons
    @IBOutlet var resetButtonButton: ActionButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
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
        
    }
    
    private func showForgotPasswordInfoVC() {
        showBottomSheet(type: .success, title: "We sent a password reset link to the email you specified. Please follow this link to reset your password.")
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
                self?.showForgotPasswordInfoVC()
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
