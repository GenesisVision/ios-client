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
    @IBOutlet weak var emailTitleLabel: SubtitleLabel! {
        didSet {
            emailTitleLabel.text = "Email"
        }
    }
    @IBOutlet weak var emailTextField: DesignableUITextField! {
        didSet {
            emailTextField.setClearButtonWhileEditing()
            emailTextField.delegate = self
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var resetButtonButton: ActionButton!
    
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
        
    }
    
    private func showForgotPasswordInfoVC() {
        showBottomSheet(.success, title: viewModel.successText) { [weak self] (success) in
            self?.viewModel.goToBack()
        }
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
