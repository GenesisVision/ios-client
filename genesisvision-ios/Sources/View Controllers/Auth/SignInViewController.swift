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

    var viewModel: SignInViewModel!
    
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
    
    // MARK: - Buttons
    @IBOutlet var signInButton: UIButton!
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
        #endif
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        emailTextField.setBottomLine()
        passwordTextField.setBottomLine()
    }
    
    private func sighInMethod() {
        hideKeyboard()
        showProgressHUD()
        
        viewModel.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { [weak self] (finish) in
                    self?.viewModel.startAsAuthorized()
                })
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func showSignUpVC() {
        hideKeyboard()
        viewModel.showSignUpVC()
    }
    
    // MARK: - Actions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        sighInMethod()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        showSignUpVC()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            sighInMethod()
        default:
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return false
    }
}
