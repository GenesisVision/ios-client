//
//  SignInViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SignIn"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        #if DEBUG
            emailTextField.text = "qqq@qqq.com"
            passwordTextField.text = "qwerty"
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Actions
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        //TODO: add verification email and password
        let loginViewModel = LoginViewModel(email: email, password: password)
        
        showProgressHUD()
        
        AccountAPI.apiInvestorAuthSignInPostWithRequestBuilder(model: loginViewModel).execute { [weak self] (response, error) in
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
                LoginProcessController.login()
            })
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        guard let viewController = SignUpViewController.storyboardInstance(name: .auth) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
