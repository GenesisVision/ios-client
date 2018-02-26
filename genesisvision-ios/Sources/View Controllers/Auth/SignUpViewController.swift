//
//  SignUpViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    var viewModel: SignUpViewModel!
    
    // MARK: - TextFields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
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
            emailTextField.text = "qqq@qqq.com"
            passwordTextField.text = "qwerty"
            confirmPasswordTextField.text = "qwerty"
        #endif
    }

    // MARK: - Private methods
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
