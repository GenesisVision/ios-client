//
//  SignInViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignInViewController: BaseViewController {

    var viewModel: AuthSignInViewModel!
    
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
    @IBOutlet var passwordTitleLabel: SubtitleLabel! {
        didSet {
            passwordTitleLabel.text = "Password"
        }
    }
    @IBOutlet var passwordTextField: DesignableUITextField! {
        didSet {
            passwordTextField.setClearButtonWhileEditing()
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet var forgotButton: UIButton! {
        didSet {
            forgotButton.setTitleColor(UIColor.Cell.title, for: .normal)
            forgotButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    private var signUpBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        #if DEBUG
        if isInvestorApp {
            emailTextField.text = "george@genesis.vision"
            passwordTextField.text = "qwerty"
        } else {
            emailTextField.text = "george+1@genesis.vision"
            passwordTextField.text = "qwerty"
        }
        #endif
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationItem.title = viewModel.title
        
        signUpBarButtonItem = UIBarButtonItem(title: "Sign up", style: .done, target: self, action: #selector(showSignUpVC))
        navigationItem.rightBarButtonItem = signUpBarButtonItem
    }
    
    private func signInMethod() {
        hideKeyboard()
        showProgressHUD()
        
        var email = emailTextField.text ?? ""
        var password = passwordTextField.text ?? ""
        
        email = email.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        
        viewModel.signIn(email: email, password: password) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { [weak self] (finish) in
                    self?.viewModel.startAsAuthorized()
                })
            case .failure(let errorType):
                switch errorType {
                case .requiresTwoFactor:
                    self?.viewModel.showTwoFactorSignInVC(email: email, password: password)
                default:
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        }
    }
    
    @objc private func showSignUpVC() {
        hideKeyboard()
        viewModel.showSignUpVC()
    }
    
    private func showForgotPasswordVC() {
        hideKeyboard()
        viewModel.showForgotPasswordVC()
    }
    
    // MARK: - Actions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        signInMethod()
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        showForgotPasswordVC()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            signInMethod()
        default:
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return false
    }
}
