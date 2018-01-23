//
//  SignInViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController, ValidableFields {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    //Fields for validate
    var validateFields: [Validation.ValidateField] {
        return [Validation.ValidateField(text: emailTextField.text ?? "", type: .email),
                Validation.ValidateField(text: passwordTextField.text ?? "", type: .password)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SignIn"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        #if DEBUG
            emailTextField.text = "qqq@qqsq.com"
            passwordTextField.text = "qwerty"
        #endif
    }
    
    // MARK: - Private methods

    private func sighInMethod() {
        //Hide keyboard
        view.endEditing(true)
        
        //If fields are valid then signIn
        guard isValid(with: validateFields) else {
            return
        }
        
        showProgressHUD()
        //SighIn with fields
        AuthController.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { (finish) in
                    AuthController.signInWithTransition()
                })
            case .failure(let reason):
                if reason != nil {
                    self?.showErrorHUD(subtitle: reason)
                }
            }
        }
    }
    
    private func showSignUpVC() {
        //TODO: Move to Router
        guard let viewController = SignUpViewController.storyboardInstance(name: .auth) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        sighInMethod()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        //Hide keyboard
        view.endEditing(true)
        
        showSignUpVC()
    }
}
