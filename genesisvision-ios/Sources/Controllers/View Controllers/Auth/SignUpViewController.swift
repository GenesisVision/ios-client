//
//  SignUpViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SignUp"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
            emailTextField.text = "qqq@qqq.com"
            passwordTextField.text = "qwerty"
            confirmPasswordTextField.text = "qwerty"
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text
        //TODO: add verification email and password
        let registerInvestorViewModel = RegisterInvestorViewModel(email: email, password: password, confirmPassword: confirmPassword)
        
        registerInvestorViewModel.confirmPassword = confirmPasswordTextField.text
        
        showProgressHUD()
        
        AccountAPI.apiInvestorAuthSignUpPostWithRequestBuilder(model: registerInvestorViewModel).execute { [weak self] (response, error) in
            guard response != nil && response?.statusCode == 200 else {
                guard let err = error as? ErrorResponse else { return }
                
                switch err {
                case .error(_, let data, _):
                    guard let data = data else {
                        self?.hideHUD()
                        return
                    }
                    let errorViewModel = try! JSONDecoder().decode(ErrorViewModel.self, from: data)
                    //TODO: get not only first message
                    guard let message = errorViewModel.errors?.first?.message else {
                        self?.hideHUD()
                        return
                    }
                    
                    self?.showErrorHUD(subtitle: message)
                }
                
                return
            }
        
            
            self?.showSuccessHUD(completion: { (finish) in
                guard let viewController = ConfirmationViewController.storyboardInstance(name: .auth) else { return }
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
        }
    }

}
