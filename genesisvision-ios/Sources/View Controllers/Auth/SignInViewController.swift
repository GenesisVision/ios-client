//
//  SignInViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    var viewModel: SignInViewModel!
    
    // MARK: - TextFields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
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
            emailTextField.text = "qqq@qqq.com"
            passwordTextField.text = "qwerty"
        #endif
    }
    
    // MARK: - Private methods
    private func sighInMethod() {
        hideKeyboard()
        showProgressHUD()
        
        viewModel.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { [weak self] (finish) in
                    self?.viewModel.startAsAuthorized()
                })
            case .failure(let reason):
                self?.showErrorHUD(subtitle: reason)
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
